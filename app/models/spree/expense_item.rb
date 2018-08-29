module Spree
  class ExpenseItem < Spree::Base

    belongs_to :variant, class_name: 'Spree::Variant'
    belongs_to :user, class_name: 'User'

    has_one :product, through: :variant
    # 一张卡可能多次充值，所以一张卡可能有多个line_item

    validates :variant,  presence: true
    validates :price, numericality: true


    self.whitelisted_ransackable_associations = %w[variant]
    self.whitelisted_ransackable_attributes = %w[store_id user_id variant_id price entry_day]

    before_create :set_defaut_day
    #初始化为待处理， 当确认工作量后 转为 done
    #state_machine initial: :pending, use_transactions: false do
    #
    #end


    # Remove variant default_scope `deleted_at: nil`
    def variant
      Spree::Variant.unscoped { super }
    end

    #应收价格
    def sale_price
      sale_unit_price * quantity * discount_percent / 100
    end


    private
    def set_defaut_day
      self.entry_day ||= DateTime.current.to_date #录入日期缺省为 今天
      self.day ||= self.entry_day                 #发生日期缺省为 今天
    end


  end
end
