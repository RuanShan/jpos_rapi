object false
child(@expenses => :expenses) do
  attributes *expense_attributes
  node(:variant_id) { |o| o.master.id }
end
node(:count) { @expenses.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @expenses.total_pages }
