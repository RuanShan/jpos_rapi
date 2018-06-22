class AddCardTransactionPosition < ActiveRecord::Migration[5.1]
  def change
    # 是否为第一次充值， 当为position = 1， 表示为新增卡的充值记录
    add_column :spree_card_transactions, :position, :integer, :null => false, default: 0

  end
end
