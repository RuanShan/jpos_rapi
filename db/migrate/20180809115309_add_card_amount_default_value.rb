class AddCardAmountDefaultValue < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:spree_cards, :amount, from: nil, to: 0)
    change_column_default(:spree_cards, :amount_used, from: nil, to: 0)

  end
end
