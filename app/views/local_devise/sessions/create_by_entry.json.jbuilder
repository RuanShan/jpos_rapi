json.(resource, :id, :username, :store_id, :api_key, :spree_role_names)

json.today_entries resource.today_entries, :id, :state, :store_id, :user_id, :day, :username, :created_at, :updated_at
