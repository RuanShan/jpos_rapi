object false
child(@card_transactions => :transactions) do
  attributes *card_transaction_attributes
end
node(:count) { @card_transactions.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @card_transactions.total_pages }
