object @user_entry
cache [I18n.locale, root_object]

attributes *user_entry_attributes
child(user: :user) do
  extends 'spree/api/v1/users/simple'
end
