if resource.present?
  json.(resource, :id, :email, :username, :api_key, :store_id, :created_at, :updated_at, :spree_role_names)
  json.today_entries resource.today_entries, :id, :state, :store_id, :user_id, :day, :username, :created_at, :updated_at
  json.avatar 'default.jpg'
else
  json.null
end
