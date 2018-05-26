if Selling::PrepaidCard.count == 0
  puts "\tCreating default PrepaidCard..."
  shipping_category = Spree::ShippingCategory.find_or_create_by(name: 'Gift Card')

  [1000, 3000, 8000].each{|i|
    product = Selling::PrepaidCard.new(available_on: Time.now, name: "PrepaidCard#{i}", price: i, shipping_category_id: shipping_category.id)
    product.card_discount_percent = { 1000=> 70, 3000=> 60, 8000=> 50}.fetch( i )
    product.save!
  }

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
