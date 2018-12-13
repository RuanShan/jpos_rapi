object @customer
#cache [I18n.locale, root_object]

attributes *customer_attributes

child(cards: :cards) do
  extends 'spree/api/v1/cards/show'
end


node(:wx_follower_nickname) { |user| user.wx_follower_nickname }
node(:wx_follower_headimgurl) { |user| user.wx_follower_headimgurl }

node(:normal_order_total) { |user| user.normal_order_total }
node(:normal_order_count) { |user| user.normal_order_count }
node(:customer_type) { |user| user.cards.present? ? '会员' : '散客' }
