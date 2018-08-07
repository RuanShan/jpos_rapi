store= Spree::Store.first


worker1= Customer.where(username: 'customer1')
    .first_or_create!( store: store, username: 'customer1', email: 'customer1@example.com', role: 'customer', mobile: '13322221234',
                     confirmed_at: Time.zone.now)
worker2= Customer.where(username: 'customer2')
   .first_or_create!( store: store, username: 'customer2', email: 'customer2@example.com', role: 'customer', mobile: '13322221231',
                     confirmed_at: Time.zone.now)
