object @card
cache [I18n.locale, root_object]
attributes *card_attributes
# product_id 计算产品打折率时需要
node(:product_id) do |c|
  c.variant.product_id
end

node(:amount_remaining, &:amount_remaining)
node(:card_times_remaining, &:card_times_remaining)
