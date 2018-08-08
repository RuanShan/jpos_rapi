object @line_item_group
cache [I18n.locale, root_object]
attributes *line_item_group_attributes

child line_items: :line_items do
  extends 'spree/api/v1/line_items/show'
end

child(order: :order) do
  attributes *order_attributes
end

node(:missing_image_url) { |group| image_path(group.missing_image_path) }
