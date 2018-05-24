object @user
#cache [I18n.locale, root_object]

attributes *user_attributes

child(cards: :cards) do
  extends 'spree/api/v1/customers/card'
end
