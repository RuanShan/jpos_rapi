Spree::Sample.load_sample("tax_categories")
Spree::Sample.load_sample("shipping_categories")

clothing = Spree::TaxCategory.find_by!(name: "Clothing")

products = [
  {
    name: "保养鞋",
    tax_category: clothing,
    price: 15.99
  },
  {
    name: "喷磨砂",
    tax_category: clothing,
    price: 22.99
  },
  {
    name: "干洗鞋",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "清洗鞋",
    tax_category: clothing,
    price: 19.99

  },
  {
    name: "翻新鞋",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "修复鞋",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "清洗上色保养",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "清洗特级保养",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "封边油",
    tax_category: clothing,
    price: 19.99
  },
  {
    name: "维修类",
    tax_category: clothing,
    price: 19.99
  }
]

default_shipping_category = Spree::ShippingCategory.find_by!(name: "Default")

products.each do |product_attrs|
  Spree::Config[:currency] = "CNY"

  new_product = Selling::Service.where(name: product_attrs[:name],
                                     tax_category: product_attrs[:tax_category]).first_or_create! do |product|
    product.price = product_attrs[:price]
    product.description = FFaker::Lorem.paragraph
    product.available_on = Time.zone.now
    product.shipping_category = default_shipping_category
  end
end

Spree::Config[:currency] = "CNY"
