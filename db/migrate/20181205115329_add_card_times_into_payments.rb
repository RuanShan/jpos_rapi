class AddCardTimesIntoPayments < ActiveRecord::Migration[5.1]
  # support inventory management
  def change
    change_table(:spree_payments) do |t|
      t.integer  "card_times", null: false, default: 0
    end

    change_table(:spree_cards) do |t|
      t.integer  "card_times", null: false, default: 0
      t.integer  "card_times_used", null: false, default: 0
    end

  end
end
