class AddAddressIdToSpreeStores < ActiveRecord::Migration[5.1]
  def change
    # https://github.com/vinsol-spree-contrib/spree_pickup
    # each store has address as customer's order ship_address for POS
    add_reference :spree_addresses, :store
  end
end
