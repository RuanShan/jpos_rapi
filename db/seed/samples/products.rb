Spree::Sample.load_sample("tax_categories")
Spree::Sample.load_sample("shipping_categories")

clothing = Spree::TaxCategory.find_by!(name: "Clothing")

products = [
  {
    name: "Ruby on Rails Tote",
    tax_category: clothing,
    price: 15.99
  },
  {
    name: "Ruby on Rails Bag",
    tax_category: clothing,
    price: 22.99
  },
  {
    name: "Ruby on Rails Baseball Jersey",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "Ruby on Rails Jr. Spaghetti",
    tax_category: clothing,
    price: 19.99

  },
  {
    name: "Ruby on Rails Ringer T-Shirt",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "Ruby Baseball Jersey",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "Apache Baseball Jersey",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "Spree Baseball Jersey",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "Spree Jr. Spaghetti",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "Spree Ringer T-Shirt",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "Spree Tote",
    tax_category: clothing,
    price: 15.99
  },
  {
    name: "Spree Bag",
    tax_category: clothing,
    price: 22.99
  },
  {
    name: "Ruby on Rails Mug",
    price: 13.99
  },
  {
    name: "Ruby on Rails Stein",
    price: 16.99
  },
  {
    name: "Spree Stein",
    price: 16.99
  },
  {
    name: "Spree Mug",
    price: 13.99
  }
]

default_shipping_category = Spree::ShippingCategory.find_by!(name: "Default")

products.each do |product_attrs|
  Spree::Config[:currency] = "CNY"
  eur_price = product_attrs.delete(:eur_price)

  new_product = Selling::Product.where(name: product_attrs[:name],
                                     tax_category: product_attrs[:tax_category]).first_or_create! do |product|
    product.price = product_attrs[:price]
    product.description = FFaker::Lorem.paragraph
    product.available_on = Time.zone.now
    product.shipping_category = default_shipping_category
  end


end

Spree::Config[:currency] = "CNY"
