module Spree
  class LineItem < Spree::Base
    before_validation :ensure_valid_quantity
    before_validation :ensure_valid_group_number

    with_options inverse_of: :line_items do
      belongs_to :order, class_name: 'Spree::Order', touch: true
      belongs_to :variant, class_name: 'Spree::Variant'
    end

    has_one :product, through: :variant
    belongs_to :store, class_name: 'Spree::Store'
    # 一张卡可能多次充值，所以一张卡可能有多个line_item
    belongs_to :card, dependent: :destroy, required: false
    belongs_to :worker, class_name: 'User', required: false
    belongs_to :line_item_group, foreign_key: 'group_id', required: false, touch: true

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
    delegate :name, to: :worker, prefix: true, allow_nil: true
    delegate :name, to: :store, prefix: true, allow_nil: true
    # code 会员卡号，老客购买新卡子订单，需要提供卡号

    #enum state: { done: 1, pending: 0 }

    self.whitelisted_ransackable_associations = %w[variant line_item_group order]
    self.whitelisted_ransackable_attributes = %w[store_id variant_id price card_id work_at worker_id]

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

    def update_discount_percent( discount )
      update_attributes(  discount_percent: discount, price: sale_unit_price* discount * 0.01 )
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
      sale_unit_price * quantity
    end

    def associate_with_card
      # use cancel a deposit
      if self.order.canceled?
        card.deposit!( self )
        return
      end
      #客户没有卡，创建新卡
      if self.card_code.present?
        card = create_card!( variant: variant, customer: self.user) do |new_card|
          new_card.code = self.card_code
          new_card.store = order.store
          new_card.created_by_id = order.created_by_id
          #new_card.amount = 0
          #new_card.name = variant.name #产品名字
          #new_card.style = variant.product.card_style #卡的种类
          #new_card.status = :enabled
        end
        self.update_attribute :card_id, card.id
      end
      #如果是充值订单
      if self.card_id > 0
        # 充值
        #self.card.transactions.create!( order: order, amount: self.price)
        card = Spree::Card.find(card_id)
        # 充值后，会员卡属于当前店铺，可能是异店办卡
        # update store_id, card.variant_id, use may upgrade card
        card.update_attributes( store_id: order.store_id, variant_id: self.variant_id, name: self.variant.name )
        card.deposit!( self )
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
      self.store_id = self.order.store_id if self.store_id.blank?
      self.product_type = product.type if self.product_type.blank?
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
