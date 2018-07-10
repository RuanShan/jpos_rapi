object @user
cache [I18n.locale, root_object]

attributes *user_attributes


child searched_entries: :searched_entries do
  attributes *user_entry_attributes
end
