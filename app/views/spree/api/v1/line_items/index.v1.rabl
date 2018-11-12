object false
child(@line_items => :line_items) do
  extends 'spree/api/v1/line_items/line_item'
end
node(:count) { @line_items.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @line_items.total_pages }
node(:total_count) { @total_count }
