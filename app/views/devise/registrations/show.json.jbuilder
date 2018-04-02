if resource.present?
  json.(resource, :id, :email, :username, :api_key, :store_id, :created_at, :updated_at)
  json.avatar 'default.jpg'
else
  json.null
end
