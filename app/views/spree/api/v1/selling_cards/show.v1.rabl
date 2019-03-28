object @product
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]

attributes *product_attributes

node(:has_variants, &:has_variants?)

node(:type, &:type)

child master: :master do
  extends 'spree/api/v1/variants/card'
end

child variants: :variants do
  extends 'spree/api/v1/variants/card'
end
