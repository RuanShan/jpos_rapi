cache [I18n.locale, root_object]
attributes *order_attributes
node(:display_item_total) { |o| o.display_item_total.to_s }
node(:total_quantity) { |o| o.line_items.sum(:quantity) }
node(:display_total) { |o| o.display_total.to_s }
node(:display_adjustment_total, &:display_adjustment_total)
node(:user_name, &:user_name)
node(:creator_name, &:creator_name)
node(:store_name, &:store_name)

child line_items: :line_items do
  extends 'spree/api/v1/line_items/show'
end

child line_item_groups: :line_item_groups do
  extends 'spree/api/v1/line_item_groups/simple'
end
