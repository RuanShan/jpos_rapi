object @line_item_group
cache [I18n.locale, root_object]
attributes *line_item_group_attributes

child images: :images do
  extends 'spree/api/v1/images/group_image_simple'
end

node(:missing_image_url) { |group| image_url(group.missing_image_path) }
