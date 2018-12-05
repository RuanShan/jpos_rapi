cache [I18n.locale, @current_user_roles.include?('admin'), 'small_variant', root_object]

attributes *variant_attributes

node(:card_discount_percent, &:card_discount_percent)
node(:card_discount_amount, &:card_discount_amount)
node(:card_times, &:card_times)
node(:display_price) { |p| p.display_price.to_s }
node(:options_text, &:options_text)
node(:is_destroyed, &:destroyed?)

child(images: :images) { extends 'spree/api/v1/images/show' }
