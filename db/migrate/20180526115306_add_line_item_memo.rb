class AddLineItemMemo < ActiveRecord::Migration[5.1]
  def change
    # 子订单对应的产品名称，以便订单API 无需 导出产品相关数据。
    # name is delegated to product
    add_column :spree_line_items, :cname, :string, limit: 128
    # 每个子订单需要备注信息
    add_column :spree_line_items, :memo, :string, limit: 128
  end
end
