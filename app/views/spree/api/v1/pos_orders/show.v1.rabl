object @order
extends 'spree/api/v1/orders/order'

child line_items: :line_items do
  extends 'spree/api/v1/line_items/show'
end

child line_item_groups: :line_item_groups do
  extends 'spree/api/v1/line_item_groups/simple'
end

child payments: :payments do
  attributes *payment_attributes

  child payment_method: :payment_method do
    attributes :id, :name
  end

  child source: :source do
      attributes *card_attributes
  end
end

child  customer: :customer do
  extends 'spree/api/v1/customers/simple'
end
