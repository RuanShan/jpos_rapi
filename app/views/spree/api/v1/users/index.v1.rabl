object false
child(@users => :users) do
  extends 'spree/api/v1/users/simple'
end
node(:count) { @users.count }
node(:current_page) { params[:page].try(:to_i) || 1 }
node(:pages) { @users.total_pages }
node(:total_count) { @total_count }
