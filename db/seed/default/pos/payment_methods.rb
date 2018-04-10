Spree::PaymentMethod::PointOfSale.where(
  name: "PointOfSale",
  description: "Pay by pos.",
  active: true,
  auto_capture: true
).first_or_create!
