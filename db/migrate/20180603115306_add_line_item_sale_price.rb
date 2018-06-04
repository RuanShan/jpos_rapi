class AddLineItemSalePrice < ActiveRecord::Migration[5.1]
  def change
    #  sale_price 商品的销售价
    #  sale_price * discount_percent = price
    add_column :spree_line_items, :sale_price, :integer, default: 0
    # discount_percent 商品打折率 100 为原价
    add_column :spree_line_items, :discount_percent, :integer, default: 0

    # 订单应收款
    add_column :spree_orders, :sale_total, :integer, default: 0
  end
end
