object false
child(@expense_items => :expense_items) do
  attributes *expense_item_attributes
end
node(:count) { @expense_items.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @expense_items.total_pages }
