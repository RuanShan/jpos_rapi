# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false
  config.default_country_id = 48 #china
  config.currency = 'CNY'
  config.track_inventory_levels = false
  #config.show_only_complete_orders_by_default = false
end

Spree.user_class = "User"

Spree::Api::Config.requires_authentication = false

#https://guides.spreecommerce.org/developer/shipments.html
#Rails.application.config.spree.stock_splitters =  [
#  Spree::Stock::Splitter::Pos
#]
