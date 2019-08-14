class AddLineItemsCardAmount < ActiveRecord::Migration[5.2]
  def change
    # 客户 card amount
    add_column :spree_line_items, :card_amount, :integer,  null: false, default: 0
  end

end
