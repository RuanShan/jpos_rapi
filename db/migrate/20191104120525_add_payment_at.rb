class AddPaymentAt < ActiveRecord::Migration[5.2]
  def change
    # 客户支付时间，便于知道入账时间
    add_column :spree_orders, :payment_at, :datetime,  default: nil
  end

end
