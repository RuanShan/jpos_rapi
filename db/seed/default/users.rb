store= Spree::Store.first

admin =User.where(username: 'admin').first_or_create(store: store, username: 'admin', email: 'admin@example.com', role: 'admin',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now, is_staff: true)
manager = User.where(username: 'manager')
    .first_or_create(store: store, username: 'manager', email: 'manager@example.com', role: 'manager', api_key: 'xxx',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now, is_staff: true)
User.where(username: 'guest')
    .first_or_create(store: store, username: 'guest', email: 'guest@example.com', role: 'guest', api_key: 'xxx',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)
waiter = User.where(username: 'waiter')
    .first_or_create(store: store, username: 'waiter', email: 'waiter@example.com', role: 'waiter',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now, is_staff: true)
waiter.update_attributes( api_key: '4ea91516400ef324dcf506969cd782739d778816f184333e')

role = Spree::Role.find_or_create_by(name: 'admin')
admin.spree_roles << role
admin.save
admin.generate_spree_api_key!


role = Spree::Role.find_or_create_by(name: 'waiter')
waiter.spree_roles << role
waiter.save



worker1= User.where(username: 'worker1')
    .first_or_create(store: store,  username: 'worker1', email: 'worker1@example.com', role: 'worker',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now, is_staff: true)
worker2= User.where(username: 'worker2')
   .first_or_create( store: store,  username: 'worker2', email: 'worker2@example.com', role: 'worker',
                    password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now, is_staff: true)

role = Spree::Role.find_or_create_by(name: 'worker')
[worker1, worker2 ].each{|w|
  w.generate_spree_api_key!
  w.spree_roles << role
  w.save
}


role = Spree::Role.find_or_create_by(name: 'qa')
[manager ].each{|w|
  w.generate_spree_api_key!
  w.spree_roles << role
  w.save
}
