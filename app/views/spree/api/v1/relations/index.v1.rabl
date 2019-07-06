object false
child(@relations => :relations) do
  attributes *relation_attributes
end
node(:count) { @relations.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @relations.total_pages }
