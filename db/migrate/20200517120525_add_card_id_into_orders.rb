class AddCardIdIntoOrders < ActiveRecord::Migration[5.2]
  def change
    # 客户支付时间，便于知道入账时间
    add_column :spree_orders, :card_id, :integer,  null: false, default: 0
  end

end
