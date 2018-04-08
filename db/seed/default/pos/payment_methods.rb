Spree::PaymentMethod::PointOfSale.where(
  name: "PointOfSale",
  description: "Pay by pos.",
  active: true
).first_or_create!
