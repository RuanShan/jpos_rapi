class AddStoreIdIntoSpreeAssets < ActiveRecord::Migration[5.1]
  # 支持异店支付功能，
  def change
    change_table(:spree_assets) do |t|
      # paid by card from other store
      t.integer :store_id, null: false, default: 0

    end

  end
end
