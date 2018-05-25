module Spree
  class Card < ActiveRecord::Base
    #include CalculatedAdjustments

    UNACTIVATABLE_ORDER_STATES = ["complete", "awaiting_return", "returned"]

    belongs_to :variant
    belongs_to :customer, class_name: 'User', foreign_key: 'user_id'

    has_many :line_items, class_name: 'Spree::LineItem'
    has_many :transactions, class_name: 'Spree::CardTransaction'
    belongs_to :created_by, class_name: 'User', optional: true
    belongs_to :sale_day, ->{ today }, class_name: 'SaleDay', counter_cache: "new_cards_count",
      primary_key: 'user_id', foreign_key: 'created_by_id'

    enum  status:{ enable: 1, disable: 0 }, _prefix: true

    validates :current_value, :name, :original_value, :code, :customer,  presence: true

    with_options allow_blank: true do
      validates :code, uniqueness: { case_sensitive: false }
      validates :current_value, numericality: { greater_than_or_equal_to: 0 }
    end

    validate :amount_remaining_is_positive, if: :current_value

    before_validation :generate_code, on: :create
    before_validation :set_values, on: :create

    delegate :product, to: :variant

    def safely_redeem(user)
      if able_to_redeem?(user)
        redeem(user)
      elsif amount_remaining.to_f > 0.0
        self.errors[:base] = Spree.t('errors.gift_card.unauthorized')
        false
      else
        self.errors[:base] = Spree.t('errors.gift_card.already_redeemed')
        false
      end
    end

    def amount_remaining
      current_value
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
      current_value > 0 &&
      !UNACTIVATABLE_ORDER_STATES.include?(order.state)
    end

    def calculator
      #@calculator ||= Spree::Calculator::GiftCardCalculator.new
    end

    def actions
      [:capture, :void]
    end

    def generate_authorization_code
      "#{id}-GC-#{Time.now.utc.strftime('%Y%m%d%H%M%S%6N')}"
    end

    def can_void?(payment)
      payment.pending?
    end

    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    private

    def redeem(user)
      begin
        transaction do
          previous_current_value = amount_remaining
          debit(amount_remaining)
          build_store_credit(user, previous_current_value).save!
        end
      rescue Exception => e
        self.errors[:base] = 'There some issue while redeeming the gift card.'
        false
      end
    end

    def build_store_credit(user, previous_current_value)
      user.store_credits.build(
            amount: previous_current_value,
            category: Spree::StoreCreditCategory.gift_card.last,
            memo: "Gift Card - #{ variant.product.name } received from #{ recieved_from }",
            created_by: user,
            action_originator: user,
            currency: Spree::Config[:currency]
        )
    end

    def recieved_from
      line_item.order.email
    end

    def generate_code
      until self.code.present? && self.class.where(code: self.code).count == 0
        self.code = Digest::SHA1.hexdigest([Time.now, rand].join)
      end
    end

    def set_values
      self.current_value ||= self.variant.try(:price)
      self.original_value ||= self.variant.try(:price)
    end

    def amount_remaining_is_positive
      unless amount_remaining >= 0.0
        errors.add(:authorized_amount, Spree.t('errors.gift_card.greater_than_current_value'))
      end
    end

    def able_to_redeem?(user)
      Spree::Config.allow_gift_card_redeem && user && user.email == email && amount_remaining.to_f > 0.0 && line_item.order.completed?
    end

  end
end
