object false
child(@orders => :orders) do
  extends 'spree/api/v1/pos_orders/order'
end
node(:count) { @orders.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @orders.total_pages }
node(:total_count) { @total_count }
