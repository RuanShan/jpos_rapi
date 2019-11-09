module Spree
  class Payment < Spree::Base
    include Spree::Core::NumberGenerator.new(prefix: 'P', letters: true, length: 7)

    include Spree::Payment::Processing

    include NumberAsParam

    NON_RISKY_AVS_CODES = ['B', 'D', 'H', 'J', 'M', 'Q', 'T', 'V', 'X', 'Y'].freeze
    RISKY_AVS_CODES     = ['A', 'C', 'E', 'F', 'G', 'I', 'K', 'L', 'N', 'O', 'P', 'R', 'S', 'U', 'W', 'Z'].freeze
    INVALID_STATES      = %w(failed invalid).freeze

    with_options inverse_of: :payments do
      belongs_to :order, class_name: 'Spree::Order', touch: true
      belongs_to :payment_method, class_name: 'Spree::PaymentMethod'
    end
    belongs_to :source, polymorphic: true

    has_many :offsets, -> { offset_payment }, class_name: 'Spree::Payment', foreign_key: :source_id
    has_many :log_entries, as: :source
    has_many :state_changes, as: :stateful
    has_many :capture_events, class_name: 'Spree::PaymentCaptureEvent'
    has_many :refunds, inverse_of: :payment

    validates :payment_method, presence: true
    validates :number, uniqueness: true

    before_validation :validate_source

    after_save :create_payment_profile, if: :profiles_supported?

    # update the order totals, etc.
    set_callback :save, :after, :update_order, unless: -> { capture_on_dispatch }

    before_create :set_default_cname #便于前端显示，即 payment_method.name
    # invalidate previously entered payments
    after_create :invalidate_old_payments
    after_create :create_eligible_credit_event


    attr_accessor :source_attributes, :request_env, :capture_on_dispatch

    after_initialize :build_source

    validates :amount, numericality: true

    delegate :store_credit?, :member_card?, to: :payment_method, allow_nil: true
    default_scope { order(:created_at) }

    scope :from_credit_card, -> { where(source_type: 'Spree::CreditCard') }
    scope :with_state, ->(s) { where(state: s.to_s) }
    # "offset" is reserved by activerecord
    scope :offset_payment, -> { where("source_type = 'Spree::Payment' AND amount < 0 AND state = 'completed'") }

    scope :checkout, -> { with_state('checkout') }
    scope :completed, -> { with_state('completed') }
    scope :pending, -> { with_state('pending') }
    scope :processing, -> { with_state('processing') }
    scope :failed, -> { with_state('failed') }

    scope :risky, -> { where("avs_response IN (?) OR (cvv_response_code IS NOT NULL and cvv_response_code != 'M') OR state = 'failed'", RISKY_AVS_CODES) }
    scope :valid, -> { where.not(state: INVALID_STATES) }

    scope :member_cards, -> { where(source_type: Spree::Card.to_s) }
    scope :store_credits, -> { where(source_type: Spree::StoreCredit.to_s) }
    scope :not_store_credits, -> { where(arel_table[:source_type].not_eq(Spree::StoreCredit.to_s).or(arel_table[:source_type].eq(nil))) }

    scope :in_day, ->(datetime){ where( arel_table['created_at'].gt(datetime.beginning_of_day).and( arel_table['created_at'].lt(datetime.end_of_day) ))}
    #scope :in_day, ->(datetime){ where( ["spree_payments.created_at>? and spree_payments.created_at<?",  datetime.beginning_of_day, datetime.end_of_day] )}

    self.whitelisted_ransackable_attributes = %w[source_id payment_method_id state]
    # transaction_id is much easier to understand
    def transaction_id
      response_code
    end

    delegate :currency, to: :order

    # order state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
    state_machine initial: :checkout do
      # With card payments, happens before purchase or authorization happens
      #
      # Setting it after creating a profile and authorizing a full amount will
      # prevent the payment from being authorized again once Order transitions
      # to complete
      event :started_processing do
        transition from: [:checkout, :pending, :completed, :processing], to: :processing
      end
      # When processing during checkout fails
      event :failure do
        transition from: [:pending, :processing], to: :failed
      end
      # With card payments this represents authorizing the payment
      event :pend do
        transition from: [:checkout, :processing], to: :pending
      end
      # With card payments this represents completing a purchase or capture transaction
      event :complete do
        transition from: [:processing, :pending, :checkout], to: :completed
      end
      event :void do
        transition from: [:pending, :processing, :completed, :checkout], to: :void
      end
      # when the card brand isnt supported
      event :invalidate do
        transition from: [:checkout], to: :invalid
      end

      after_transition do |payment, transition|
        payment.state_changes.create!(
          previous_state: transition.from,
          next_state:     transition.to,
          name:           'payment'
        )
        # 无需计算，订单状态改变，统一处理，没有取消某一个支付方式的操作。 办卡支付也不会。
        #payment.update_sale_day_fields( transition.from, transition.to)
      end
    end

    def money
      Spree::Money.new(amount, currency: currency)
    end
    alias display_amount money

    def amount=(amount)
      self[:amount] =
        case amount
        when String
          separator = I18n.t('number.currency.format.separator')
          number    = amount.delete("^0-9-#{separator}\.").tr(separator, '.')
          number.to_d if number.present?
        end || amount
    end

    def offsets_total
      offsets.sum(:amount)
    end

    def credit_allowed
      amount - (offsets_total.abs + refunds.sum(:amount))
    end

    def can_credit?
      credit_allowed > 0
    end

    # see https://github.com/spree/spree/issues/981
    def build_source
      return unless new_record?
      if source_attributes.present? && source.blank? && payment_method.try(:payment_source_class)
        self.source = payment_method.payment_source_class.new(source_attributes)
        source.payment_method_id = payment_method.id
        source.user_id = order.user_id if order
      end
    end

    def actions
      return [] unless payment_source && payment_source.respond_to?(:actions)
      payment_source.actions.select { |action| !payment_source.respond_to?("can_#{action}?") || payment_source.send("can_#{action}?", self) }
    end

    def payment_source
      res = source.is_a?(Payment) ? source.source : source
      res || payment_method
    end

    def is_avs_risky?
      return false if avs_response.blank? || NON_RISKY_AVS_CODES.include?(avs_response)
      true
    end

    def is_cvv_risky?
      return false if cvv_response_code == 'M'
      return false if cvv_response_code.nil?
      return false if cvv_response_message.present?
      true
    end

    def captured_amount
      capture_events.sum(:amount)
    end

    def uncaptured_amount
      amount - captured_amount
    end

    def editable?
      checkout? || pending?
    end


    # update sale_day depend on payment state
    def update_sale_day_fields( transition_from, transition_to)
      # new order or canceled
      # => service_total,  deposit_total

      if transition_to== "completed" && order.order_type_normal? && order.sale_day
        order.sale_day.service_total += self.amount
        order.sale_day.save!
      end
      if transition_to== "void" && order.order_type_normal? && order.sale_day
        order.sale_day.service_total -= self.amount
        order.sale_day.save!
      end

    end

    private

    def has_invalid_state?
      INVALID_STATES.include?(state)
    end

    def validate_source
      if source && !source.valid?
        source.errors.each do |field, error|
          field_name = I18n.t("activerecord.attributes.#{source.class.to_s.underscore}.#{field}")
          errors.add(Spree.t(source.class.to_s.demodulize.underscore), "#{field_name} #{error}")
        end
      end
      !errors.present?
    end

    def profiles_supported?
      payment_method.respond_to?(:payment_profiles_supported?) && payment_method.payment_profiles_supported?
    end

    def create_payment_profile
      # Don't attempt to create on bad payments.
      return if has_invalid_state?
      # Payment profile cannot be created without source
      return unless source
      # Imported payments shouldn't create a payment profile.
      return if source.imported

      payment_method.create_profile(self)
    rescue ActiveMerchant::ConnectionError => e
      gateway_error e
    end

    def split_uncaptured_amount
      if uncaptured_amount > 0
        order.payments.create!(
          amount: uncaptured_amount,
          payment_method: payment_method,
          source: source,
          state: 'pending',
          capture_on_dispatch: true
        ).authorize!
        update_attributes(amount: captured_amount)
      end
    end

    def update_order
      order.updater.update_payment_total if completed? || void?

      if order.completed?
        order.updater.update_payment_state
      end

      order.persist_totals if completed? || order.completed?
    end

    def create_eligible_credit_event
      # When cancelling an order, a payment with the negative amount
      # of the payment total is created to refund the customer. That
      # payment has a source of itself (Spree::Payment) no matter the
      # type of payment getting refunded, hence the additional check
      # if the source is a store credit.
      return unless store_credit? && source.is_a?(Spree::StoreCredit)

      # creates the store credit event
      source.update_attributes!(action: Spree::StoreCredit::ELIGIBLE_ACTION,
                                action_amount: amount,
                                action_authorization_code: response_code)
    end

    #支付方式为会员卡时，调整会员卡余额,  payment.purchase 方法中创建 card_transaction
    #def create_eligible_card_event
    #  Rails.logger.debug "member_card?=#{member_card?} source=#{source.inspect}"
    #  return unless member_card? && source.is_a?(Spree::Card)
    #  source.capture!(self)
    #end

    def invalidate_old_payments
      #允许同时使用多种支付方式，所以屏蔽这个方法
      return
      # invalid payment or store_credit payment shouldn't invalidate other payment types
      return if has_invalid_state? || store_credit? || member_card?

      Rails.logger.debug "=== before invalidate_old_payments"
      order.payments.with_state('checkout').where.not(id: id).each do |payment|
        payment.invalidate! unless payment.store_credit?
      end
      Rails.logger.debug "=== after invalidate_old_payments"

    end

    def set_default_cname
      if self.cname.blank?
        self.cname = self.payment_method.name
        if self.source.is_a? Spree::Card
          self.cname +="(#{self.source.code})"
        end
      end
    end
  end
end
