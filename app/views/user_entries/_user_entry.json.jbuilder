json.extract! user_entry, :id, :state, :store_id, :user_id, :created_at, :updated_at
json.url user_entry_url(user_entry, format: :json)
