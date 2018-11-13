class AddDayIntoStockMovements < ActiveRecord::Migration[5.1]
  # support inventory management
  def change
    change_table(:spree_stock_movements) do |t|
      t.date  :day
      t.string :memo, length: 255
      t.references :created_by
    end
  end
end
