if Selling::PrepaidCard.count == 0
  puts "\tCreating default PrepaidCard..."
  shipping_category = Spree::ShippingCategory.create(name: 'Gift Card')
  product = Selling::PrepaidCard.new(available_on: Time.now, name: "Gift Card", slug: 'gift-card', price: 0, shipping_category_id: shipping_category.id)
  option_type = Spree::OptionType.new(name: "is-gift-card", presentation: "Value")
  product.option_types << option_type
  [200, 500, 1000].each do |value|
    option_value = Spree::OptionValue.new(name: value, presentation: "#{value}")
    option_value.option_type = option_type
    opts = { price: value.to_i, sku: "CARDCERT#{value}" }
    variant = Spree::Variant.new(opts)
    variant.option_values << option_value
    product.variants << variant
  end
  product.save

end

unless Spree::PaymentMethod::PrepaidCard.all.exists?
  Spree::PaymentMethod::PrepaidCard.create(
    name: "PrepaidCard",
    description: "Pay by PrepaidCard",
    active: true,
    display_on: :both
  )
end
# 
# unless Spree::PaymentMethod::AnnualCard.all.exists?
#   Spree::PaymentMethod::AnnualCard.create(
#     name: "AnnualCard",
#     description: "Pay by AnnualCard",
#     active: true,
#     display_on: :both
#   )
# end
