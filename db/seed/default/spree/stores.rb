# Possibly already created by a migration.
unless Spree::Store.where(code: 'spree').exists?
  store = Spree::Store.new do |s|
    s.code              = 'spree'
    s.name              = '示例门店'
    s.url               = '1.example.com'
    s.mail_from_address = '1@example.com'
  end
  store.save!



  # Spree::Address.new do |s|
  #   s.firstname = 'store'
  #   s.lastname = 'address'
  #   s.address1 = 'some address'
  #   s.country_id = Spree::Config[:default_country_id]
  #   s.state_id = Spree::State.where(abbr: 'LN').first.id
  #   s.city = 'Dalian'
  #   s.zipcode = '116000'
  #   s.phone = '66898939'
  #   s.store_id = store.id
  # end.save
  # create shipping_method for pos
  # create payment_method for pos
end

unless Spree::Store.where(code: 'spree2').exists?
  (2..5).each{ |i|
    store = Spree::Store.new do |s|
      s.code              = "spree#{i}"
      s.name              = "示例门店"
      s.url               = "#{i}.example.com"
      s.mail_from_address = "#{i}@example.com"
    end
    store.save!
  }

end
