class AddTypeIntoStores < ActiveRecord::Migration[5.1]
  # support inventory management
  def change
    change_table(:spree_stores) do |t|
      t.string :type, limit: 32  # suport factory/store
    end

  end
end
