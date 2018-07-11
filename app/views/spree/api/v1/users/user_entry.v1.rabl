object @user
cache [I18n.locale, root_object]

attributes *user_attributes


child searched_entries: :searched_entries do
  extends 'spree/api/v1/user_entries/simple'

end
