Spree::Sample.load_sample("addresses")

orders = []
orders << Spree::Order.where(
  number: "R123456789",
  email: "spree@example.com").first_or_create! do |order|
    order.store = Spree::Store.first
    order.item_total = 150.95
    order.adjustment_total = 150.95
    order.total = 301.90
  end

orders << Spree::Order.where(
  number: "R987654321",
  email: "spree@example.com").first_or_create! do |order|
    order.store = Spree::Store.first
    order.item_total = 15.95
    order.adjustment_total = 15.95
    order.total = 31.90
    order.shipping_address = Spree::Address.first
    order.billing_address = Spree::Address.last
  end

unless orders[0].line_items.any?
  orders[0].line_items.new(
    variant: Spree::Product.find_by!(name: "Ruby on Rails Tote").master,
    quantity: 1,
    price: 15.99).save!
end

unless orders[1].line_items.any?
  orders[1].line_items.new(
    variant: Spree::Product.find_by!(name: "Ruby on Rails Bag").master,
    quantity: 1,
    price: 22.99).save!
end

orders.each(&:create_proposed_shipments)

orders.each do |order|
  order.state = "complete"
  order.completed_at = Time.current - 1.day
  order.save!
end
