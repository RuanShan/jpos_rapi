module Spree
  module PermittedAttributes
    ATTRIBUTES = [
      :address_attributes,
      :card_attributes,
      :checkout_attributes,
      :customer_return_attributes,
      :customer_attributes,
      :image_attributes,
      :inventory_unit_attributes,
      :line_item_attributes,
      :option_type_attributes,
      :option_value_attributes,
      :payment_attributes,
      :product_attributes,
      :product_properties_attributes,
      :property_attributes,
      :return_authorization_attributes,
      :shipment_attributes,
      :source_attributes,
      :stock_item_attributes,
      :stock_location_attributes,
      :stock_movement_attributes,
      :store_attributes,
      :store_credit_attributes,
      :taxon_attributes,
      :taxonomy_attributes,
      :user_attributes,
      :variant_attributes
    ]

    mattr_reader *ATTRIBUTES

    @@address_attributes = [
      :id, :firstname, :lastname, :first_name, :last_name,
      :address1, :address2, :city, :country_id, :state_id,
      :zipcode, :phone, :state_name, :alternative_phone, :company,
      country: [:iso, :name, :iso3, :iso_name],
      state: [:name, :abbr]
    ]
    # 状态，折扣，备注，过期时间
    @@card_attributes = [ :code, :variant_id, :amount, :status, :discount_percent, :memo, :expire_at]

    @@checkout_attributes = [
      :coupon_code, :email, :shipping_method_id, :special_instructions, :use_billing, :user_id,
      :order_type, :created_by_id
    ]

    @@customer_return_attributes = [:stock_location_id, return_items_attributes: [:id, :inventory_unit_id, :return_authorization_id, :returned, :pre_tax_amount, :acceptance_status, :exchange_variant_id, :resellable]]

    @@customer_attributes = [:store_id, :email, :username, :mobile, :payment_password,

      :payment_password_confirmation, :birth, :address, :memo, :gender]

    @@image_attributes = [:alt, :attachment, :position, :viewable_type, :viewable_id]

    @@inventory_unit_attributes = [:shipment, :shipment_id, :variant_id]

    # code: 新创建的会员卡号
    @@line_item_attributes = [:id, :variant_id, :quantity, :group_number, :card_id, :sale_unit_price, :sale_price, :price, :discount_percent, :memo, :cname, :code ]

    @@option_type_attributes = [:name, :presentation, :option_values_attributes]

    @@option_value_attributes = [:name, :presentation]

    @@payment_attributes = [:amount, :payment_method_id, :payment_method, :source_id, :source_type]

    @@product_properties_attributes = [:property_name, :value, :position]

    @@product_attributes = [
      :name, :description, :available_on, :discontinue_on, :permalink, :meta_description,
      :meta_keywords, :price, :sku, :deleted_at, :prototype_id,
      :option_values_hash, :weight, :height, :width, :depth,
      :shipping_category_id, :tax_category_id,
      :cost_currency, :cost_price,
      option_type_ids: [], taxon_ids: []
    ]

    @@property_attributes = [:name, :presentation]

    @@return_authorization_attributes = [:amount, :memo, :stock_location_id, :inventory_units_attributes, :return_authorization_reason_id]

    @@shipment_attributes = [
      :order, :special_instructions, :stock_location_id, :id,
      :tracking, :address, :inventory_units, :selected_shipping_rate_id]

    # month / year may be provided by some sources, or others may elect to use one field
    @@source_attributes = [
      :number, :month, :year, :expiry, :verification_value,
      :first_name, :last_name, :cc_type, :gateway_customer_profile_id,
      :gateway_payment_profile_id, :last_digits, :name, :encrypted_data]

    @@stock_item_attributes = [:variant, :stock_location, :backorderable, :variant_id]

    @@stock_location_attributes = [
      :name, :active, :address1, :address2, :city, :zipcode,
      :backorderable_default, :state_name, :state_id, :country_id, :phone,
      :propagate_all_variants]

    @@stock_movement_attributes = [
      :quantity, :stock_item, :stock_item_id, :originator, :action]

    @@store_attributes = [:name, :url, :seo_title, :meta_keywords,
                          :meta_description, :default_currency, :mail_from_address]

    @@store_credit_attributes = [:amount, :category_id, :memo]

    @@taxonomy_attributes = [:name]

    @@taxon_attributes = [
      :name, :parent_id, :position, :icon, :description, :permalink, :taxonomy_id,
      :meta_description, :meta_keywords, :meta_title, :child_index]

    # TODO: Should probably use something like Spree.user_class.attributes
    @@user_attributes = [:email, :username, :mobile, :password, :password_confirmation, :payment_password, :payment_password_confirmation, :birth, :address, :memo]

    @@variant_attributes = [
      :name, :presentation, :cost_price, :discontinue_on, :lock_version,
      :position, :track_inventory,
      :product_id, :product, :option_values_attributes, :price,
      :weight, :height, :width, :depth, :sku, :cost_currency,
      options: [:name, :value], option_value_ids: []
    ]
  end
end
