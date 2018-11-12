class AddStoreIdIntoLineItmes < ActiveRecord::Migration[5.1]
  # support inventory management
  def change
    change_table(:spree_line_items) do |t|
      t.references  "store"
      t.string :product_type, limit: 32  # so we know it is card/service/other
    end

  end
end
