class AddIsPosToSpreeOrders < ActiveRecord::Migration[5.1]
  def change
    # order.channel 'pos'来自店内pos系统,
    # order_type: 订单类型
    # 1: 充值订单
    add_column :spree_orders, :order_type, :integer, null: false, default: 0

    # 订单中客户物品数量，如果为0，说明
    add_column :spree_orders, :group_count, :integer, null: false, default: 0

  end
end
