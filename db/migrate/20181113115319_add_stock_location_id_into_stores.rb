class AddStockLocationIdIntoStores < ActiveRecord::Migration[5.1]
  # support inventory management
  def change
    change_table(:spree_stores) do |t|
      t.references  "stock_location"
    end
  end
end
