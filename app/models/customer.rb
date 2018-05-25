class Customer < User
  default_scope { where( is_staff: false ) }

  validates :mobile, presence: true, uniqueness: true

  # 包括客户 消费订单 和 购买会员卡，会员卡充值订单
  has_many :orders, class_name: 'Spree::Order', foreign_key: 'user_id'
  has_many :cards, class_name: 'Spree::Card', foreign_key: 'user_id'


  #总共消费金额
  def normal_order_total
    orders.where( order_type: :normal ).sum(:total)
  end
  #总共消费次数
  def normal_order_count
    orders.where( order_type: :normal ).count
  end
end
