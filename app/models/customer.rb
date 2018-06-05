class Customer <  ApplicationRecord

  validates :mobile, presence: true, uniqueness: true

  belongs_to :created_by, class_name: 'User', optional: true
  belongs_to :store, class_name: 'Spree::Store'
  #服务员创建新会员的日子，一天新注册了多少用户统计
  belongs_to :sold_day, ->{ today }, class_name: 'SaleDay', counter_cache: 'new_customers_count',
    primary_key: 'user_id', foreign_key: 'created_by_id', optional: true

  # 包括客户 消费订单 和 购买会员卡，会员卡充值订单
  has_many :orders, class_name: 'Spree::Order', foreign_key: 'user_id'
  has_many :cards, class_name: 'Spree::Card', foreign_key: 'user_id'

  before_validation :set_login
  alias_attribute :name, :username # order.user_name required

  #总共消费金额
  def normal_order_total
    orders.where( order_type: :normal ).sum(:total)
  end
  #总共消费次数
  def normal_order_count
    orders.where( order_type: :normal ).count
  end

  private

    def set_login
      # for now force login to be same as email, eventually we will make this configurable, etc.
      self.username = self.mobile if (self.mobile.present? && self.username.blank? )
    end

end
