class CancelLineItemGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_orders, :memo, :text

    # 添加物品返工信息
    add_column :spree_line_item_groups, :returned_by_id, :integer
    add_column :spree_line_item_groups, :returned_at, :datetime

    # 添加物品取消信息
    add_column :spree_line_item_groups, :canceled_by_id, :integer
    add_column :spree_line_item_groups, :canceled_at, :datetime

  end
end
