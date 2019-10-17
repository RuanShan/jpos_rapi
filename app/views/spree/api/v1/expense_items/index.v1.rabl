object false
child(@expense_items => :expense_items) do
  extends 'spree/api/v1/expense_items/show'
end
node(:count) { @expense_items.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @expense_items.total_pages }
node(:total_count) { @total_count }
node(:total_sum) { @total_sum }
