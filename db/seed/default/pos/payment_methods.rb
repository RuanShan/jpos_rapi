unless Spree::PaymentMethod::PrepaidCard.all.exists?
  Spree::PaymentMethod::PrepaidCard.create(
    name: "PrepaidCard",
    description: "Pay by PrepaidCard",
    active: false,
    display_on: :both
  )
end

Spree::PaymentMethod::PointOfSale.where(
  name: "POS",
  description: "PointOfSale",
  active: true,
  auto_capture: true
).first_or_create!


Spree::PaymentMethod::Cash.where(
  name: "现金",
  description: "现金支付",
  active: true,
  auto_capture: true
).first_or_create!

Spree::PaymentMethod::Weixin.where(
  name: "微信",
  description: "微信支付",
  active: true,
  auto_capture: true
).first_or_create!

Spree::PaymentMethod::Alipay.where(
  name: "支付宝",
  description: "支付宝",
  active: true,
  auto_capture: true
).first_or_create!

Spree::PaymentMethod::Unionpay.where(
  name: "银联",
  description: "银联支付",
  active: true,
  auto_capture: true
).first_or_create!
