json.user do
  if resource.present?
    json.(resource, :id, :email, :username,  :created_at, :updated_at)
  end
  json.avatar 'default.jpg'

end
