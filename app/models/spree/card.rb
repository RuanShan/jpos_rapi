module Spree
  class Card < ActiveRecord::Base
    #include CalculatedAdjustments

    UNACTIVATABLE_ORDER_STATES = ["complete", "awaiting_return", "returned"]

    belongs_to :variant
    belongs_to :customer, class_name: 'Customer', foreign_key: 'user_id'

    has_many :line_items, class_name: 'Spree::LineItem'
    #has_many :transactions, class_name: 'Spree::CardTransaction'
    belongs_to :created_by, class_name: 'User', optional: true
    belongs_to :sale_day, ->{ today }, class_name: 'SaleDay', counter_cache: "new_cards_count",
    primary_key: 'user_id', foreign_key: 'created_by_id'

    enum  status:{ enabled: 1, disabled: 0 }, _prefix: true
    enum  style:{ counts: 1, prepaid: 0 }, _prefix: true

    validates :amount_used, :name, :amount, :code, :customer,  presence: true

    with_options allow_blank: true do
      validates :code, uniqueness: { case_sensitive: false }
      validates :amount_used, numericality: { greater_than_or_equal_to: 0 }
    end

    validate :amount_remaining_is_positive

    before_validation :generate_code, on: :create
    before_validation :set_values, on: :create

    delegate :product, to: :variant

    def amount_remaining
      amount - amount_used
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
      "#{id}-GC-#{Time.now.utc.strftime('%Y%m%d%H%M%S%6N')}"
    end

    def can_void?(payment)
      payment.pending?
    end

    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    def capture!( payment )
      self.amount_used += payment.amount
      self.save!
    end

    private


    def generate_code
      until self.code.present? && self.class.where(code: self.code).count == 0
        self.code = Digest::SHA1.hexdigest([Time.now, rand].join)
      end
    end

    def set_values
      self.amount ||= self.variant.try(:price)
      self.amount_used = 0
    end

    def amount_remaining_is_positive
      unless amount_remaining >= 0.0
        errors.add(:authorized_amount, Spree.t('errors.gift_card.greater_than_amount_used'))
      end
    end

  end
end
