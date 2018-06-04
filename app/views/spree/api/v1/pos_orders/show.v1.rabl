object @order
extends 'spree/api/v1/orders/order'

if lookup_context.find_all("spree/api/v1/orders/#{root_object.state}").present?
  extends "spree/api/v1/orders/#{root_object.state}"
end

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
    if @current_user_roles.include?('admin')
      attributes *payment_source_attributes + [:gateway_customer_profile_id, :gateway_payment_profile_id]
    else
      attributes *payment_source_attributes
    end
  end
end
