if Selling::PrepaidCard.count == 0
  puts "\tCreating default PrepaidCard..."
  shipping_category = Spree::ShippingCategory.find_or_create_by(name: 'Gift Card')

  [1000, 2000, 5000].each{|i|
    product = Selling::PrepaidCard.new(available_on: Time.now, name: "PrepaidCard#{i}", price: i, shipping_category_id: shipping_category.id)
    product.save!
  }

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
