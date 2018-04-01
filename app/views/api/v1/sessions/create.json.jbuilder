json.session do
  json.(@user, :id, :username, :role)
  json.token @user.api_key
end
