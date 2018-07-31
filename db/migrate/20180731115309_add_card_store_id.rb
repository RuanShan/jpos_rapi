class AddCardStoreId < ActiveRecord::Migration[5.1]
  def change
    change_table(:spree_cards) do |t|
      #开卡店铺
      t.column :store_id, :integer

    end
  end
end
