require 'spree/order/checkout'

module Spree
  class Order < Spree::Base
    #pending: 未付款， paid: 已付款
    PAYMENT_STATES = %w(unpaid balance_due credit_owed pending failed paid void)
    GROUP_STATES = %w(pending ready_for_factory processing processed ready_for_store ready)
    SHIPMENT_STATES = %w(backorder canceled partial pending ready shipped ready_for_factory processing ready_for_store)
    include Spree::Order::Checkout

    include Spree::Core::NumberGenerator.new(prefix: 'R')
    include Spree::Core::TokenGenerator

    include NumberAsParam
    extend Spree::DisplayMoney
    money_methods :outstanding_balance, :total, :item_total

    MONEY_THRESHOLD  = 100_000_000
    MONEY_VALIDATION = {
      presence:     true,
      numericality: {
        greater_than: -MONEY_THRESHOLD,
        less_than:     MONEY_THRESHOLD,
        allow_blank:   true
      },
      format:       { with: /\A-?\d+(?:\.\d{1,2})?\z/, allow_blank: true }
    }.freeze

    POSITIVE_MONEY_VALIDATION = MONEY_VALIDATION.deep_dup.tap do |validation|
      validation.fetch(:numericality)[:greater_than_or_equal_to] = 0
    end.freeze

    NEGATIVE_MONEY_VALIDATION = MONEY_VALIDATION.deep_dup.tap do |validation|
      validation.fetch(:numericality)[:less_than_or_equal_to] = 0
    end.freeze


    extend Spree::DisplayDateTime
    date_time_methods :created_at

    self.whitelisted_ransackable_associations = %w[shipments user promotions bill_address ship_address line_items line_item_groups payments store]
    self.whitelisted_ransackable_attributes = %w[store_id completed_at email number state payment_state group_state shipment_state total order_type created_at user_id odd_card_paid odd_store_id]

    attr_reader :coupon_code
    attr_accessor :temporary_address, :temporary_credit_card

    belongs_to :user, class_name: "Customer", optional: true
    belongs_to :creator, class_name: "User", foreign_key: "created_by_id", optional: true
    belongs_to :approver, class_name: "User", optional: true
    belongs_to :canceler, class_name: "User", optional: true
    belongs_to :store, class_name: 'Spree::Store', required: true
    # sale_day should be day of order created
    belongs_to :sale_day, ->(order){ where( store_id: order.store_id, day: order.created_at.to_date ) }, class_name: 'SaleDay', counter_cache: 'new_orders_count',
      primary_key: 'user_id', foreign_key: 'created_by_id', inverse_of: 'new_orders'

    with_options dependent: :destroy do
      has_many :state_changes, as: :stateful
      has_many :line_items, -> { order(:created_at) }, inverse_of: :order
      has_many :payments
      has_many :return_authorizations, inverse_of: :order
      has_many :adjustments, -> { order(:created_at) }, as: :adjustable
    end

    has_many :variants, through: :line_items
    has_many :products, through: :variants
    has_many :refunds, through: :payments

    has_many :line_item_groups, dependent: :destroy, inverse_of: :order do
      def states
        pluck(:state).uniq
      end
    end
    has_many :card_transactions, dependent: :destroy, inverse_of: :order


    accepts_nested_attributes_for :line_items
    accepts_nested_attributes_for :payments


    before_create :create_token
    before_create :link_by_email
    after_destroy :update_sale_day_fields

    with_options presence: true do
      validates :number, length: { maximum: 32, allow_blank: true }, uniqueness: { allow_blank: true }
      validates :email, length: { maximum: 254, allow_blank: true }, email: { allow_blank: true }, if: :require_email
      validates :item_count, numericality: { greater_than_or_equal_to: 0, less_than: 2**31, only_integer: true, allow_blank: true }
    end
    validates :payment_state,        inclusion:    { in: PAYMENT_STATES, allow_blank: true }
    validates :item_total,           POSITIVE_MONEY_VALIDATION
    validates :payment_total,        MONEY_VALIDATION
    validates :total,                MONEY_VALIDATION

    delegate :update_totals, :persist_totals, :update_prices,  to: :updater
    delegate :merge!, to: :merger
    delegate :name, to: :creator, prefix: true, allow_nil: true
    delegate :name, to: :user, prefix: true, allow_nil: true
    delegate :name, to: :store, prefix: true, allow_nil: true

    class_attribute :update_hooks
    self.update_hooks = Set.new

    class_attribute :line_item_comparison_hooks
    self.line_item_comparison_hooks = Set.new


    scope :payment_in_day, ->(datetime){ where( ["payment_at>? and payment_at<?",  datetime.beginning_of_day, datetime.end_of_day] )}
    scope :in_day, ->(datetime){ where( ["created_at>? and created_at<?",  datetime.beginning_of_day, datetime.end_of_day] )}

    scope :created_between, ->(start_date, end_date) { where(created_at: start_date..end_date) }
    scope :completed_between, ->(start_date, end_date) { where(completed_at: start_date..end_date) }
    scope :complete, -> { where.not(completed_at: nil) }
    scope :incomplete, -> { where(completed_at: nil) }

    # shows completed orders first, by their completed_at date, then uncompleted orders by their created_at
    scope :reverse_chronological, -> { order(Arel.sql('spree_orders.completed_at IS NULL'), completed_at: :desc, created_at: :desc) }

    scope :type_normal, -> { where( order_type: :normal ) }
    scope :type_card, -> { where( order_type: [:card, :deposit] ) }
    scope :type_counter, -> { where( order_type: :counter ) }


    scope :inprogress_groups, -> { type_normal.where( state: :cart, group_state: [:pending, :ready_for_factory, :processing,  :processed, :ready_for_store, :ready] ) }
    # 0： 服务订单， 1：买卡订单， 2：二次充值订单, 3: 商品订单
    enum order_type: { normal: 0,  card: 1,  deposit: 2, counter: 3 }, _prefix: true

    alias_attribute :customer_id, :user_id
    alias_attribute :customer, :user

    class_attribute :line_item_comparison_hooks
    self.line_item_comparison_hooks = Set.new
    # params
    #  { "store_id": 1,
    #    "user_id": 8,
    #    "created_by_id": 4,
    #    "line_items_attributes": [ { "variant_id": 15, "quantity": 1, "group_position": 1 }]
    #  }
    def self.make_order( params )
      @order = self.create( params )
      @order.complete_via_pos
    end

    # For compatiblity with Calculator::PriceSack
    def amount
      line_items.inject(0.0) { |sum, li| sum + li.amount }
    end



    def currency
      self[:currency] || Spree::Config[:currency]
    end



    def completed?
      completed_at.present?
    end

    # Indicates whether or not the user is allowed to proceed to checkout.
    # Currently this is implemented as a check for whether or not there is at
    # least one LineItem in the Order.  Feel free to override this logic in your
    # own application if you require additional steps before allowing a checkout.
    def checkout_allowed?
      line_items.exists?
    end

    # Is this a free order in which case the payment step should be skipped
    def payment_required?
      total.to_f > 0.0
    end



    def updater
      @updater ||= OrderUpdater.new(self)
    end

    def update_with_updater!
      updater.update
    end

    def merger
      @merger ||= Spree::OrderMerger.new(self)
    end

    def allow_cancel?
      return true
      #return false if !completed? || canceled?
      #shipment_state.nil? || %w{ready backorder pending}.include?(shipment_state)
    end


    def contents
      @contents ||= Spree::OrderContents.new(self)
    end

    # Associates the specified user with the order.
    def associate_user!(user, override_email = true)
      self.user           = user
      self.email          = user.email if override_email
      self.creator   ||= user

      changes = slice(:user_id, :email, :created_by_id, :bill_address_id, :ship_address_id)

      # immediately persist the changes we just made, but don't use save
      # since we might have an invalid address associated
      self.class.unscoped.where(id: self).update_all(changes)
    end

    def quantity_of(variant, options = {})
      line_item = find_line_item_by_variant(variant, options)
      line_item ? line_item.quantity : 0
    end

    def find_line_item_by_variant(variant, options = {})
      line_items.detect do |line_item|
        line_item.variant_id == variant.id &&
          line_item_options_match(line_item, options)
      end
    end

    # This method enables extensions to participate in the
    # "Are these line items equal" decision.
    #
    # When adding to cart, an extension would send something like:
    # params[:product_customizations]={...}
    #
    # and would provide:
    #
    # def product_customizations_match
    def line_item_options_match(line_item, options)
      return true unless options

      line_item_comparison_hooks.all? do |hook|
        send(hook, line_item, options)
      end
    end



    def update_line_item_prices!
      transaction do
        line_items.each(&:update_price)
        save!
      end
    end



    # Finalizes an in progress order after checkout is complete.
    # Called after transition to complete state when payments will have been processed
    def finalize!

      # update payment and shipment(s) states, and save
      updater.update_payment_state


      save!
      updater.run_hooks

      touch :completed_at

    end

    def fulfill!
      shipments.each { |shipment| shipment.update!(self) if shipment.persisted? }
      updater.update_shipment_state
      save!
    end
    #商品流程，进行下一步处理
    def one_step!( forward=true)

      if forward
        line_item_groups.each { |item| item.next!(self) }
      else
        line_item_groups.each { |item| item.draw_back!(self) }
      end
      updater.update_group_state
      save!
    end



    # Helper methods for checkout steps
    def paid?
      payment_state == 'paid' || payment_state == 'credit_owed'
    end

    def available_payment_methods
      @available_payment_methods ||= collect_payment_methods
    end




    def state_changed(name)
      state = "#{name}_state"
      if persisted?
        old_state = send("#{state}_was")
        new_state = send(state)
        unless old_state == new_state
          state_changes.create(
            previous_state: old_state,
            next_state:     new_state,
            name:           name,
            user_id:        user_id
          )
        end
      end
    end

    def coupon_code=(code)
      @coupon_code = begin
                       code.strip.downcase
                     rescue
                       nil
                     end
    end




    def restart_checkout_flow
      update_columns(
        state: 'cart',
        updated_at: Time.current
      )
      next! unless line_items.empty?
    end



    def is_risky?
      !payments.risky.empty?
    end

    def canceled_by(user)
      transaction do
        cancel!
        update_columns(
          canceler_id: user.id,
          canceled_at: Time.current
        )
      end
    end

    def approved_by(user)
      transaction do
        approve!
        update_columns(
          approver_id: user.id,
          approved_at: Time.current
        )
      end
    end

    def approved?
      !!approved_at
    end

    def can_approve?
      !approved?
    end

    def consider_risk
      considered_risky! if is_risky? && !approved?
    end

    def considered_risky!
      update_column(:considered_risky, true)
    end

    def approve!
      update_column(:considered_risky, false)
    end

    def reload(options = nil)
      remove_instance_variable(:@tax_zone) if defined?(@tax_zone)
      super
    end

    def quantity
      line_items.sum(:quantity)
    end


    def collect_backend_payment_methods
      PaymentMethod.available_on_back_end.select { |pm| pm.available_for_order?(self) }
    end



    def payments_attributes=(attributes)
      validate_payments_attributes(attributes)
      super(attributes)
    end

    def validate_payments_attributes(attributes)
      # Ensure the payment methods specified are allowed for this user
      payment_methods = Spree::PaymentMethod.where(id: available_payment_methods.map(&:id))
      attributes.each do |payment_attributes|
        payment_method_id = payment_attributes[:payment_method_id]

        # raise RecordNotFound unless it is an allowed payment method
        payment_methods.find(payment_method_id) if payment_method_id
      end
    end

    ############################################################################
    # handle pos
    ############################################################################
    def complete_via_pos
      groups = create_line_item_groups
      # lock all adjustments (coupon promotions, etc.)
      #all_adjustments.each(&:close)
      # update payment and shipment(s) states, and save
      #shipments.each do |shipment|
      #  shipment.update!(self)
      #  shipment.finalize!
      #end
      #updater.update_shipment_state
      #保证会员卡，现金等支付为完成状态。
      payments.each(&:capture!)

      updater.update

      #update payment_state after total, payment_total updated
      update_column( :payment_state, updater.update_payment_state )

      #updater.run_hooks
      #不能 touch completed_at, 删除时会导致 OrderInventory.verify 异常
      touch :completed_at

      #如果是会员卡订单， 购买，充值等
      associate_card_if_needed if self.order_type_card_or_deposit?

      #在创建会员卡后再统计
      update_sale_day_fields

      #根据配置，发出公众号、短信，或邮件通知
      notify_customer
    end


    def create_line_item_groups
      #如果创建 line_item_groups时， payments 存在，说明客户已经付款，否则为未付款订单
      groups_map = {}
      group_payment_state = payments.present? ? :paid : :unpaid

      line_items.each{|line_item|
        #这个line_item 可能不是一个服务，可能是充值卡，或鞋油等实物商品
        #对于这些line_item无需创建line_item_group
        #line_item_group, 代表的是一件客户物品
        next unless line_item.product.is_a?(Selling::Service)
        line_item_group = groups_map[line_item.group_position]
        if line_item_group.blank?
          group_number = generate_group_number
          group = Spree::LineItemGroup.create!(
            store_id: self.store_id,
            order: self,
            number: group_number,
            price: line_item.price,
            payment_state: group_payment_state,
            name: "#{line_item.name}(#{line_item.options_text})"
          )
          line_item.update_attributes( group_id: group.id, group_number: group_number)
          groups_map[line_item.group_position] = group
        else
          line_item.update_attributes( group_id: line_item_group.id, group_number: line_item_group.number )
          line_item_group.price += line_item.price
          line_item_group.name += " / #{line_item.name}(#{line_item.options_text})"
          line_item_group.save
        end
      }
      groups_map.values
    end


    def outstanding_balance
      if canceled?
        -1 * payment_total
      elsif refunds.exists?
        # If refund has happened add it back to total to prevent balance_due payment state
        # See: https://github.com/spree/spree/issues/6229 & https://github.com/spree/spree/issues/8136
        total - (payment_total + refunds.sum(:amount))
      else
        total - payment_total
      end
    end

    def outstanding_balance?
      outstanding_balance != 0
    end

    #显示支付状态
    def display_payment_method_names
      if payments.present?
        payments.pluck(:cname).join(',')
      else
        "未付款"
      end
    end
    #
    def order_type_card_or_deposit?
      order_type_card? || order_type_deposit?
    end


    def update_sale_day_fields
      # new order or canceled
      # => service_total,  deposit_total
      if self.sale_day

        if order_type_card?
          # if (destroyed? && !canceled?) || canceled?
          #   self.sale_day.new_cards_count -= 1
          #   self.sale_day.deposit_total -= self.total
          # else
          #   self.sale_day.new_cards_count+=1
          #   self.sale_day.deposit_total+= self.total
          # end
          # 新卡数需要统计card表
          #new_cards_count = Spree::Card.in_day( self.created_at ).where( store_id: self.store_id, created_by_id: self.created_by_id).status_enabled.count
          new_cards_count = Spree::Card.in_day( self.created_at ).where( store_id: self.store_id).status_enabled.count
          deposit_total =  Spree::Order.in_day( self.created_at   ).where( created_by_id: self.created_by_id, store_id: self.store_id, order_type: [:card, :deposit] ).with_state(:cart).sum(:payment_total)

          self.sale_day.new_cards_count = new_cards_count
          self.sale_day.deposit_total = deposit_total

        elsif order_type_deposit?
          # if (destroyed? && !canceled?) || canceled?
          #   self.sale_day.deposit_total -= self.total
          # else
          #   self.sale_day.deposit_total+= self.total
          # end
          deposit_total =  Spree::Order.in_day( self.created_at ).where( created_by_id: self.created_by_id, store_id: self.store_id, order_type: [:card, :deposit] ).with_state(:cart).sum(:payment_total)
          self.sale_day.deposit_total = deposit_total

        elsif order_type_normal?
            # if (destroyed? && !canceled?) || canceled?
            #   self.sale_day.service_order_count -= 1
            #   # this order may be unpaid or parital
            # else
            #   self.sale_day.service_order_count += 1
            #   # add totle when payment is completed
            #   #self.sale_day.service_total += self.total
            # end
            # payment_at in day, 如果没有支付 payment_at is null
            count = Spree::Order.in_day(  self.created_at ).where( created_by_id: self.created_by_id, store_id: self.store_id ).type_normal.with_state(:cart).count
            self.sale_day.service_order_count = count
            if self.payment_at.present?
              service_total =  Spree::Order.in_day( self.created_at ).where( created_by_id: self.created_by_id, store_id: self.store_id, order_type: [:normal] ).with_state(:cart).sum(:payment_total)
              # 当天收入是多少, 包括现金、支付宝、微信、pos？
              method_ids = Spree::PaymentMethod.where( posable: true ).pluck(:id)
              service_posable_total = Spree::Payment.completed.in_day(self.payment_at).joins(:order).where( payment_method_id: method_ids, spree_orders:{ created_by_id: self.created_by_id, store_id: self.store_id, order_type: [:normal], state: :cart }).sum(:amount)
              self.sale_day.service_total = service_total
              self.sale_day.service_posable_total = service_posable_total
            end
        end
        self.sale_day.save!
      end
    end

    private

    def notify_customer
      if enable_mp_msg
        if canceled?
            MpMsgJob.perform_later(self,  MpMsgJob::TemplateTypeEnum.order_canceled )
        else
          if order_type_normal?
            MpMsgJob.perform_later(self,  MpMsgJob::TemplateTypeEnum.new_order_created )
          elsif order_type_card?
            MpMsgJob.perform_later(self,  MpMsgJob::TemplateTypeEnum.deposit_success )
          else
            MpMsgJob.perform_later(self,  MpMsgJob::TemplateTypeEnum.new_order_created )
          end
        end
      end
      if enable_sms
        unless canceled?
          if order_type_normal?
            SmsJob.perform_later(self,  SmsJob::TemplateTypeEnum.new_order_created )
          elsif  order_type_counter?
            SmsJob.perform_later(self,  SmsJob::TemplateTypeEnum.new_order_created )
          end
        end
      end
    end

    def associate_card_if_needed
        self.line_items.each{ |item| item.associate_with_card  }
    end

    def link_by_email
      self.email = user.email if user
    end

    # Determine if email is required (we don't want validation errors before we hit the checkout)
    def require_email
      return false
      #true unless new_record? || ['cart', 'address'].include?(state)
    end

    def ensure_line_items_present
      unless line_items.present?
        errors.add(:base, Spree.t(:there_are_no_items_for_this_order)) && (return false)
      end
    end



    def after_cancel
      Rails.logger.debug "after_cancel1... "
      # shipments.each(&:cancel!)
      # 订单取消，不需要每个物品再分别取消
      # line_item_groups.uncanceled.each(&:cancel!)
      payments.completed.each(&:cancel!)

      Rails.logger.debug "after_cancel2... "
      # Free up authorized store credits
      #payments.store_credits.pending.each(&:void!)
      #associate_card_if_needed if self.order_type_card?

      #send_cancel_email
      update_with_updater!
      Rails.logger.debug "after_cancel3... "

      #如果是会员卡订单， 购买，充值等
      associate_card_if_needed if self.order_type_card_or_deposit?

      update_sale_day_fields
      # send sms, mp message
      notify_customer
    end


    def send_cancel_email
      OrderMailer.cancel_email(id).deliver_later
    end

    def after_resume
      shipments.each(&:resume!)
      consider_risk
    end

    def use_billing?
      use_billing.in?([true, 'true', '1'])
    end

    def set_currency
      self.currency = Spree::Config[:currency] if self[:currency].nil?
    end

    def create_token
      self.guest_token ||= generate_guest_token
    end

    def collect_payment_methods
      PaymentMethod.available_on_front_end.select { |pm| pm.available_for_order?(self) }
    end


    def generate_group_number
      # "0823010001" 取后四位
      max = (self.store.line_item_groups.today.maximum(:number)||'')[-4,4].to_i
      #Rails.logger.debug(" max number = #{store.line_item_groups.today.maximum(:number)} max=#{max}")
      #date.to_s(:number)        # => "20071110"
      # 4byte(date)-2byte(store_id)-4byte(count)
      "%s%02d%04d" % [created_at.to_s(:number)[4,4], store_id, max+1]
    end
  end
end
