class AddCardTimesIntoLineItmes < ActiveRecord::Migration[5.1]
  # support inventory management
  def change
    change_table(:spree_variants) do |t|
      t.integer  "card_times", null: false, default: 0
    end

  end
end
