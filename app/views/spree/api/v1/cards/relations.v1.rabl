object false
child(@card_relations => :relations) do
  attributes *card_transaction_attributes
end
node(:count) { @card_relations.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @card_relations.total_pages }
