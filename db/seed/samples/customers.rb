worker1= User.where(username: 'customer1')
    .first_or_create!( username: 'customer1', email: 'customer1@example.com', role: 'customer', mobile: '13322221234'
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)
worker2= User.where(username: 'customer2')
   .first_or_create!(  username: 'customer2', email: 'customer2@example.com', role: 'customer', mobile: '13322221231'
                    password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)
