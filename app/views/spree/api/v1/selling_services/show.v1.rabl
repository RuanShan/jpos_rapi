object @product
cache [I18n.locale, @current_user_roles.include?('admin'), current_currency, root_object]

attributes *product_attributes

node(:display_price) { |p| p.display_price.to_s }
node(:has_variants, &:has_variants?)
node(:taxon_ids, &:taxon_ids)

child master: :master do
  extends 'spree/api/v1/variants/service'
end

child variants: :variants do
  extends 'spree/api/v1/variants/service'
end

child relateds: :relateds do
  attributes *relation_attributes
end
