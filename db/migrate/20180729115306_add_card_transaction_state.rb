class AddCardTransactionState < ActiveRecord::Migration[5.1]
  def change
    change_table(:spree_card_transactions) do |t|
      #状态， 成功，取消
      t.column :state, :string, limit: 16
      #原因, 充值订单，取消订单
      t.column :reason, :string, limit: 16
      #交易号
      t.column :auth_code, :string, limit: 32
    end

  end
end
