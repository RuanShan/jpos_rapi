require "ffaker"

default_shipping_category = Spree::ShippingCategory.find_by!(name: "Default")

products = [
  {
    name: "鞋油",
    price: 50
  },
  {
    name: "鞋掌",
    price: 20
  }
]


products.each do |product_attrs|
  Spree::Config[:currency] = "CNY"

  new_product = Selling::Counter.where(name: product_attrs[:name]).first_or_create! do |product|
    product.price = product_attrs[:price]
    product.description = FFaker::Lorem.paragraph
    product.available_on = Time.zone.now
    product.shipping_category = default_shipping_category
  end


end
