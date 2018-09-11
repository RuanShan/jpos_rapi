module Spree
  class ExpenseItem < Spree::Base

    belongs_to :store, class_name: 'Spree::Store'
    belongs_to :user, class_name: 'User'
    belongs_to :expense_category, class_name: 'Spree::ExpenseCategory'


    validates :expense_category,  presence: true
    validates :price, numericality: true


    self.whitelisted_ransackable_associations = %w[expense_category]
    self.whitelisted_ransackable_attributes = %w[store_id user_id expense_category_id price entry_day]

    before_create :set_defaut_day
    #初始化为待处理， 当确认工作量后 转为 done
    #state_machine initial: :pending, use_transactions: false do
    #
    #end

    delegate :name, to: :store, prefix: true
    delegate :name, to: :user, prefix: true
    delegate :name, to: :expense_category, prefix: true

    # Remove expense_category default_scope `deleted_at: nil`
    def expense_category
      Spree::ExpenseCategory.unscoped { super }
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
