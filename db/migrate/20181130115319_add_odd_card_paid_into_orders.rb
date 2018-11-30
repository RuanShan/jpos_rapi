class AddOddCardPaidIntoOrders < ActiveRecord::Migration[5.1]
  # 支持转卡功能， 即一张卡上的余额转到另外一张上
  def change
    change_table(:spree_orders) do |t|
      # paid by card from other store
      t.boolean "odd_card_paid", null: false, default: false
    end

  end
end
