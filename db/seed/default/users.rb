User.where(username: 'admin')
    .first_or_create(username: 'admin', email: 'admin@example.com', role: 'admin',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)
User.where(username: 'manager')
    .first_or_create(username: 'manager', email: 'manager@example.com', role: 'manager',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)
User.where(username: 'guest')
    .first_or_create(username: 'guest', email: 'guest@example.com', role: 'guest',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)
User.where(username: 'test')
    .first_or_create(username: 'waiter', email: 'waiter@example.com', role: 'waiter',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)
