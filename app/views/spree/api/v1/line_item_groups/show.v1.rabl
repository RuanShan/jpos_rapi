object @line_item_group
cache [I18n.locale, root_object]
attributes *line_item_group_attributes
node(:order_id) { |line_item_group| line_item_group.order.number }

child line_items: :line_items do
  extends 'spree/api/v1/line_items/show'
end

child order: :order do
  extends 'spree/api/v1/orders/order'
  
end
