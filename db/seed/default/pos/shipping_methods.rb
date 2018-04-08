shipping_category = Spree::ShippingCategory.find_or_create_by!(name: 'Default')


shipping_methods = [
  {
    name: "PointOfSale",
    display_on: 'back_end',
    shipping_categories: [shipping_category]
  }]

shipping_methods.each do |attributes|
  Spree::ShippingMethod.where(name: attributes[:name]).first_or_create! do |shipping_method|
    shipping_method.calculator = Spree::Calculator::Shipping::FlatRate.create!
    shipping_method.display_on = attributes[:display_on]
    shipping_method.shipping_categories = attributes[:shipping_categories]
  end
end
