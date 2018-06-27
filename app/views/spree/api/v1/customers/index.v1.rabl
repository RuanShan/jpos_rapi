object false
child(@customers => :users) do
  extends 'spree/api/v1/customers/show'
end
node(:count) { @customers.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @customers.total_pages }
node(:total_count) { @total_count }
