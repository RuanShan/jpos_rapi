class AddCardAmountLeft < ActiveRecord::Migration[5.1]
  def change
    # 充值前剩余数量
    add_column :spree_card_transactions, :amount_left, :decimal, :precision => 8, :scale => 2, :null => false

  end
end
