module Spree
  class LineItem < Spree::Base
    before_validation :ensure_valid_quantity
    before_validation :ensure_valid_group_number

    with_options inverse_of: :line_items do
      belongs_to :order, class_name: 'Spree::Order', touch: true
      belongs_to :variant, class_name: 'Spree::Variant'
    end

    has_one :product, through: :variant
    # 一张卡可能多次充值，所以一张卡可能有多个line_item
    belongs_to :card, dependent: :destroy, required: false
    belongs_to :worker, class_name: 'User', dependent: :destroy, required: false
    belongs_to :line_item_group, foreign_key: 'group_number', primary_key: 'number'

    before_validation :copy_price

    validates :variant, :order, presence: true
    validates :quantity, numericality: { only_integer: true, message: Spree.t('validation.must_be_int') }
    validates :price, numericality: true

    #不需要检查库存
    #validates_with Stock::AvailabilityValidator

    # 在订单创建成功，并支付成功后，创建 会员卡ID
    validate :ensure_card_code_unique, if: -> { card_code.present? }


    #after_save :update_inventory

    delegate :name, :description, :sku, :should_track_inventory?, :product, :options_text, to: :variant

    delegate :is_card?, to: :product
    delegate :user, to: :order

    # code 会员卡号，老客购买新卡子订单，需要提供卡号

    #enum state: { done: 1, pending: 0 }

    self.whitelisted_ransackable_associations = %w[variant]
    self.whitelisted_ransackable_attributes = %w[variant_id price]

    #初始化为待处理， 当确认工作量后 转为 done
    state_machine initial: :pending, use_transactions: false do
      event :fulfill do
        transition from: :pending, to: :done
      end
    end

    def copy_price
      if variant
        update_price if price.nil?
        self.cost_price = variant.cost_price if cost_price.nil?
        self.currency = variant.currency if currency.nil?
      end
    end

    def update_price
      self.price = variant.price
    end


    extend DisplayMoney
    money_methods :amount, :subtotal, :discounted_amount, :final_amount, :total, :price

    alias single_money display_price
    alias single_display_amount display_price

    def amount
      price * quantity
    end

    alias subtotal amount


    alias discounted_money display_discounted_amount

    def final_amount
      amount + adjustment_total
    end

    alias total final_amount
    alias money display_total


    def options=(options = {})
      return unless options.present?

      opts = options.dup # we will be deleting from the hash, so leave the caller's copy intact

      currency = opts.delete(:currency) || order.try(:currency)

      update_price_from_modifier(currency, opts)
      assign_attributes opts
    end

    # Remove variant default_scope `deleted_at: nil`
    def variant
      Spree::Variant.unscoped { super }
    end

    #应收价格
    def sale_price
      sale_unit_price * quantity * discount_percent / 100
    end

    def associate_with_card
      #客户没有卡，创建新卡
      if self.card_code.present?
        card = create_card!( variant: variant, customer: self.user) do |new_card|
          new_card.code = self.card_code
          new_card.amount = 0
          new_card.name = variant.name #产品名字
          new_card.store = order.store
          new_card.creator = order.creator
          new_card.style = variant.product.card_style #卡的种类
          if variant.card_expire_in > 0
            new_card.expire_in =  DateTime.current.in( card_expire_in.day )
          end
          new_card.discount_percent = variant.card_discount_percent
          new_card.discount_amount = variant.card_discount_amount
          new_card.status = :enabled
        end
        self.update_attribute :card_id, card.id
      end
      #如果是充值订单
      if self.card_id > 0
        # 充值
        #self.card.transactions.create!( order: order, amount: self.price)
        Spree::Card.find(card_id).deposit!( self )
      end
    end

    def cancel_associated_card
      if self.code.present?
        #删除创建的会员卡
        Spree::Card.find_by( code: self.code).destroy()

      end
    end

    private


    def ensure_valid_quantity
      self.quantity = 0 if quantity.nil? || quantity < 0
    end

    def ensure_valid_group_number
      #如果为空，使用产品名称
      self.cname = self.name if self.cname.blank?
      #self.group_number ||= generate_group_number
    end

    def generate_group_number
      #"2018-04-14T15:39:30+08:00" =>"20180414154023"
      DateTime.current.to_s(:number) + ("%04d" % order.store_id)
    end

    def update_price_from_modifier(currency, opts)
      if currency
        self.currency = currency
        # variant.price_in(currency).amount can be nil if
        # there's no price for this currency
        self.price = (variant.price_in(currency).amount || 0) +
          variant.price_modifier_amount_in(currency, opts)
      else
        self.price = variant.price +
          variant.price_modifier_amount(opts)
      end
    end


    def ensure_card_code_unique
      if Spree::Card.exists?( code: card_code )
        errors.add(:card_code, :existed)
      end
    end

    #工人工作量验收
    def associate_with_worker( worker )
      if work_at.present?
        previous_date = work_at
        User.find( self.worker_id ).recompute_processed_line_items_count previous_date
      end

      self.worker  = worker
      self.work_at = DateTime.current.to_date
      self.save
      User.find( self.worker_id ).recompute_processed_line_items_count
    end

  end
end
