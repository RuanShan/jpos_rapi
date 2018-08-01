unless Spree::PaymentMethod::PrepaidCard.all.exists?
  Spree::PaymentMethod::PrepaidCard.create(
    name: "会员卡",
    description: "会员卡支付",
    active: true,
    display_on: :both
  )
end

Spree::PaymentMethod::Cash.where(
  name: "现金",
  description: "现金支付",
  active: true,
  auto_capture: true,
  posable: true
).first_or_create!

Spree::PaymentMethod::Weixin.where(
  name: "微信",
  description: "微信支付",
  active: true,
  auto_capture: true,
  posable: true
).first_or_create!

Spree::PaymentMethod::Alipay.where(
  name: "支付宝",
  description: "支付宝",
  active: true,
  auto_capture: true,
  posable: true
).first_or_create!

Spree::PaymentMethod::Unionpay.where(
  name: "银联",
  description: "银联支付",
  active: true,
  auto_capture: true,
  posable: true
).first_or_create!
