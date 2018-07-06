class AddPaymentStateInfoLineItemGroup < ActiveRecord::Migration[5.1]
  def change

    # 对于未付款订单，客户取回物品时，需要付款，如果物品是多个，并且客户只取回了部分订单
    # 这时需要更新物品的 payment_state
    change_table(:spree_line_item_groups) do |t|
      t.column :payment_state, :string
      # Other column alterations here
    end

  end
end
