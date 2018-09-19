cache [I18n.locale, root_object]
attributes *order_attributes
node(:total_quantity) { |o| o.line_items.sum(:quantity) }

node(:token, &:guest_token)
node(:user_name, &:user_name)
node(:store_name, &:store_name)
node(:creator_name, &:creator_name)
