class AddCheckoutPasswordRequiredIntoStores < ActiveRecord::Migration[5.1]
  # support inventory management
  def change
    change_table(:spree_stores) do |t|
      t.boolean :checkout_password_required, null: false, default: false  # suport factory/store
    end

  end
end
