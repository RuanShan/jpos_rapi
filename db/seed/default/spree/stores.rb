# Possibly already created by a migration.
unless Spree::Store.where(code: 'spree').exists?
  Spree::Store.new do |s|
    s.code              = 'spree'
    s.name              = 'Spree Demo Site'
    s.url               = 'example.com'
    s.mail_from_address = 'spree@example.com'
  end.save!


  # create shipping_method for pos
  # create payment_method for pos

end
