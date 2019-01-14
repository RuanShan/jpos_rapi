Warden::Manager.after_authentication do |user,auth,opts|
#  user.generate_spree_api_key! if user
end

Warden::Manager.before_logout do |user,auth,opts|
#  user.clear_spree_api_key! if user
end
