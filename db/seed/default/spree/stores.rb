# Possibly already created by a migration.
unless Spree::Store.where(code: 'spree').exists?
  store = Spree::Store.new do |s|
    s.code              = 'spree'
    s.name              = 'Spree Demo Site'
    s.url               = 'example.com'
    s.mail_from_address = 'spree@example.com'
  end
  store.save!


  Spree::Address.new do |s|
    s.firstname = 'store'
    s.lastname = 'address'
    s.address1 = 'some address'
    s.country_id = Spree::Config[:default_country_id]
    s.state_id = Spree::State.where(abbr: 'LN').first.id
    s.city = 'Dalian'
    s.zipcode = '116000'
    s.phone = '66898939'
    s.store_id = store.id
  end.save!
  # create shipping_method for pos
  # create payment_method for pos

end
