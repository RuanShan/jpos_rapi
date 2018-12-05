module Spree
  class Card < ActiveRecord::Base

    acts_as_paranoid

    include AuditorGeneralModel
    auditable attributes: [:password, :variant_id], create: false, destroy: false

    UNACTIVATABLE_ORDER_STATES = ["complete", "awaiting_return", "returned"]

    belongs_to :store
    belongs_to :variant
    belongs_to :customer, class_name: 'Customer', foreign_key: 'user_id'

    has_many :line_items, class_name: 'Spree::LineItem'
    has_many :card_transactions, class_name: 'Spree::CardTransaction'
    #会员卡创建人员是必须的，以便查找 卡所属 店铺ID
    belongs_to :creator, class_name: 'User', foreign_key: 'created_by_id', optional: true

    has_many :state_changes, as: :stateful

    scope :with_state, ->(s) { where(state: s.to_s) }

    # 会员卡的可用和禁用状态, 使用state代替
    enum  status:{ enabled: 1, disabled: 0 }, _prefix: true
    # 次卡 和 充值卡
    enum  style:{ times: 1, prepaid: 0 }, _prefix: true

    validates :amount_used, :name, :amount, :code, :customer,  presence: true

    with_options allow_blank: true do
      validates :code, uniqueness: { case_sensitive: false }
      validates :amount_used, numericality: { greater_than_or_equal_to: 0 }
    end

    validate :amount_remaining_is_positive

    before_validation :generate_code, on: :create
    before_validation :set_values, on: :create

    delegate :product, to: :variant
    delegate :name, to: :store, prefix: true

    state_machine initial: :enabled, use_transactions: false do
      event :disable do
        transition from: :enabled, to: :disabled
      end
      event :enable do
        transition from: :disabled, to: :enabled
      end
      event :replace do
        transition from: any, to: :replaced
      end

      after_transition do |card, transition|
        card.state_changes.create!(
          previous_state: transition.from,
          next_state:     transition.to,
          name:           'card'
        )
      end
    end

    def amount_remaining
      amount - amount_used
    end

    def card_times_remaining
      card_times - card_times_used
    end

    # Calculate the amount to be used when creating an adjustment
    def compute_amount(calculable)
      0
      #self.calculator.compute(calculable, self)
    end


    def price
      self.line_item ? self.line_item.price * self.line_item.quantity : self.variant.price
    end

    def order_activatable?(order)
      order &&
      created_at < order.created_at &&
      amount_used > 0 &&
      !UNACTIVATABLE_ORDER_STATES.include?(order.state)
    end

    def calculator
      #@calculator ||= Spree::Calculator::GiftCardCalculator.new
    end

    def actions
      [:capture, :void]
    end

    def generate_authorization_code
      "A#{Time.now.utc.strftime('%Y%m%d%H%M%S%6N')}"
    end

    def can_void?(payment)
      payment.pending?
    end

    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    # #支付
    # def capture!( payment )
    #   self.order_id = payment.order_id
    #   self.amount_used += payment.amount
    #   self.save!
    # end

    #充值
    def deposit!( line_item )
      #当为position = 1， 表示为新增卡的充值记录
      if style_times? # 次卡 TimesCard
        card_times = line_item.variant.cart_times
        card_transaction = self.card_transactions.create!( order: line_item.order, amount: card_times, amount_left: self.card_times_remaining, reason: 'deposit')
      else
        card_transaction = self.card_transactions.create!( order: line_item.order, amount: line_item.price, amount_left: self.amount_remaining, reason: 'deposit')
      end

      card_transaction.deposit
    end

    #支付
    def capture( amount, auth_code, gateway_options )

      order = Spree::Order.find_by_number gateway_options[:order_number]
      payment = Spree::Payment.find_by_number gateway_options[:payment_number]
      if style_times? # 次卡 TimesCard
        card_transaction = self.card_transactions.create!( order:order,  amount: -payment.card_times, amount_left: self.card_times_remaining, reason: 'consume'  )
      else
        card_transaction = self.card_transactions.create!( order:order,  amount: -amount, amount_left: self.amount_remaining, reason: 'consume'  )
      end
      card_transaction.capture
      card_transaction.id
    end

    #取消订单，取消相应的支付
    def cancel( auth_code )
      card_transaction = self.card_transactions.find_by( id: auth_code)
      if style_times? # 次卡 TimesCard
        new_card_transaction = self.card_transactions.create!( order: card_transaction.order,  amount: -card_transaction.amount, amount_left: self.card_times_remaining, reason: 'canceled'  )
      else
        new_card_transaction = self.card_transactions.create!( order: card_transaction.order,  amount: -card_transaction.amount, amount_left: self.amount, reason: 'canceled'  )
      end
      new_card_transaction.capture
      new_card_transaction.id
    end

    #替换会员卡
    def replace_with( new_card )
      self.transfer_to( new_card )
      self.replaced_with_id = new_card.id
      self.replaced_at = DateTime.current
      self.replace!
    end
    #将卡内余额转至新卡
    def transfer_to( new_card )
      new_card_transaction = new_card.card_transactions.create!(   amount: self.amount_remaining, amount_left: new_card.amount_remaining, reason: 'transfer'  )
      new_card_transaction.deposit
      card_transaction = self.card_transactions.create!(   amount: -self.amount_remaining, amount_left: 0, reason: 'transfer'  )
      card_transaction.capture

      new_card.reload
    end

    private
    def validate_authorization(amount, order_currency)
      if amount_remaining.to_d < amount.to_d
        errors.add(:base, Spree.t('store_credit_payment_method.insufficient_funds'))
      end
      errors.blank?
    end

    def generate_code
      until self.code.present? && self.class.where(code: self.code).count == 0
        self.code = Digest::SHA1.hexdigest([Time.now, rand].join)
      end
    end

    def set_values
      self.status = :enabled
      self.name ||= variant.try(:name)
      self.amount ||= 0
      if variant
        self.style = product.try(:card_style) #卡的种类
        if variant.card_expire_in > 0
          self.expire_at =  DateTime.current.in( variant.card_expire_in.day )
        end
        if product.is_a? Selling::PrepaidCard
          self.discount_percent = variant.card_discount_percent
          self.discount_amount = variant.card_discount_amount
        elsif product.is_a? Selling::TimesCard
          self.card_times = variant.card_times
        end
      end
      self.amount_used = 0
    end

    def amount_remaining_is_positive
      unless amount_remaining >= 0.0
        errors.add(:authorized_amount, Spree.t('errors.gift_card.greater_than_amount_used'))
      end
    end

  end
end
