object false
child(@user_entries => :user_entries) do
  extends 'spree/api/v1/user_entries/simple'
end
node(:count) { @user_entries.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @user_entries.total_pages }
node(:total_count) { @total_count }
