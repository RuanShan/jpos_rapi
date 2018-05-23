cache [I18n.locale, @current_user_roles.include?('admin'), 'small_variant', root_object]

attributes *variant_attributes

node(:display_price) { |p| p.display_price.to_s }
node(:options_text, &:options_text)
node(:is_destroyed, &:destroyed?)

child option_values: :option_values do
  attributes *option_value_attributes
end

child(images: :images) { extends 'spree/api/v1/images/show' }
