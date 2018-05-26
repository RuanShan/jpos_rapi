object false
child(@collection => :payment_methods) do
  attributes *payment_method_attributes
end
node(:count) { @collection.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @collection.total_pages }
