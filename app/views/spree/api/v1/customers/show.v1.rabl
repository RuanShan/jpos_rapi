object @user
#cache [I18n.locale, root_object]

attributes *user_attributes


child(cards: :cards) do
  extends 'spree/api/v1/customers/card'
end

node(:order_total) { |user| user.order_total }
node(:order_count) { |user| user.order_count }
node(:customer_type) { |user| user.cards.present? ? '会员' : '散客' }
