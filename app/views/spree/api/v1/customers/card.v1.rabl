object @card
attributes *card_attributes
# product_id 计算产品打折率时需要
node(:product_id) do |c|
  c.variant.product_id
end
