object false
child(@line_item_groups => :line_item_groups) do
  extends 'spree/api/v1/line_item_groups/line_item_group'
end
node(:count) { @line_item_groups.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @line_item_groups.total_pages }
node(:total_count) { @total_count }
