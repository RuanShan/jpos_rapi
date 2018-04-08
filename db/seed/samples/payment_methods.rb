Spree::Gateway::Bogus.where(
  name: "Credit Card",
  description: "Bogus payment gateway.",
  active: false
).first_or_create!

Spree::PaymentMethod::Check.where(
  name: "Check",
  description: "Pay by check.",
  active: false
).first_or_create!
