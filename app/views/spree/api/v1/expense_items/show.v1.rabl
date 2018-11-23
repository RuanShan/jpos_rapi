object @expense_item
attributes *expense_item_attributes
node(:user_name) { |o| o.user.username }
node(:store_name) { |o| o.store_name }
child images: :images do
  extends 'spree/api/v1/images/expense_image'
end
