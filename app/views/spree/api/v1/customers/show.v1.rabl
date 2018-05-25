object @user
#cache [I18n.locale, root_object]

attributes *user_attributes


child(cards: :cards) do
  extends 'spree/api/v1/customers/card'
end

node(:normal_order_total) { |user| user.normal_order_total }
node(:normal_order_count) { |user| user.normal_order_count }
node(:customer_type) { |user| user.cards.present? ? '会员' : '散客' }
