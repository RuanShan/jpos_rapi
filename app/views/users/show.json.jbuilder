json.user do
  json.(@user, :id, :email, :username,  :created_at, :updated_at)
  node(:spree_role_names) 

end
