class Customer < User
  default_scope { where( is_staff: false ) }

  validates :mobile, presence: true, uniqueness: true

  has_many :orders, class_name: 'Spree::Order', foreign_key: 'user_id'
  has_many :cards, class_name: 'Spree::Card', foreign_key: 'user_id'


  #总共消费金额
  def order_total
    orders.sum(:total)
  end
  #总共消费次数
  def order_count
    orders.count
  end
end
