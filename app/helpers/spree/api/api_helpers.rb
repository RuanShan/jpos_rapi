module Spree
  module Api
    module ApiHelpers
      ATTRIBUTES = [
        :address_attributes,
        :adjustment_attributes,
        :country_attributes,
        :card_attributes,
        :card_transaction_attributes,
        :creditcard_attributes,
        :customer_attributes,
        :customer_return_attributes,
        :expense_category_attributes,
        :expense_item_attributes,
        :expense_attributes,
        :image_attributes,
        :inventory_unit_attributes,
        :line_item_attributes,
        :line_item_group_attributes,
        :option_value_attributes,
        :order_attributes,
        :option_type_attributes,
        :payment_attributes,
        :payment_method_attributes,
        :payment_source_attributes,
        :promotion_attributes,
        :product_attributes,
        :product_property_attributes,
        :property_attributes,
        :reimbursement_attributes,
        :relation_attributes,
        :return_authorization_attributes,
        :sale_day_attributes,
        :shipment_attributes,
        :state_attributes,
        :stock_location_attributes,
        :stock_movement_attributes,
        :stock_item_attributes,
        :store_attributes,
        :tag_attributes,
        :taxonomy_attributes,
        :taxon_attributes,
        :user_attributes,
        :user_entry_attributes,
        :variant_attributes,
      ]

      mattr_reader *ATTRIBUTES

      def required_fields_for(model)
        required_fields = model._validators.select do |_field, validations|
          validations.any? { |v| v.is_a?(ActiveModel::Validations::PresenceValidator) }
        end.map(&:first) # get fields that are invalid
        # Permalinks presence is validated, but are really automatically generated
        # Therefore we shouldn't tell API clients that they MUST send one through
        required_fields.map!(&:to_s).delete('permalink')
        # Do not require slugs, either
        required_fields.delete('slug')
        required_fields
      end

      @@card_attributes = [
        :id, :store_id, :user_id, :code, :style, :amount, :amount_used,
        :name, :discount_percent, :discount_amount, :status, :memo, :created_at,
        :expire_at, :variant_id, :state, :payment_password
      ]
      @@card_transaction_attributes = [
        :id, :card_id, :order_id, :amount,  :amount_left,:position,  :created_at
      ]
      @@expense_category_attributes = [
        :id, :name, :description
      ]
      @@expense_item_attributes = [
        :id, :store_id, :user_id, :expense_category_id, :variant_id, :cname, :memo, :price, :day, :entry_day, :created_at
      ]
      @@expense_attributes = [
        :id, :name
      ]
      @@product_attributes = [
        :id, :name, :description, :price, :display_price, :available_on,
        :slug, :meta_description, :meta_keywords, :shipping_category_id,
        :taxon_ids, :total_on_hand
      ]

      @@product_property_attributes = [
        :id, :product_id, :property_id, :value, :property_name
      ]

      @@variant_attributes = [
        :id, :name, :sku, :price, :weight, :height, :width, :depth, :is_master,
        :slug, :description, :track_inventory
      ]

      @@image_attributes = [
        :id, :position, :attachment_content_type, :attachment_file_name, :type,
        :attachment_updated_at, :attachment_width, :attachment_height, :alt
      ]

      @@option_value_attributes = [
        :id, :name, :presentation, :option_type_name, :option_type_id,
        :option_type_presentation
      ]

      @@order_attributes = [
        :id, :number, :item_total, :total, :ship_total, :state, :adjustment_total,
        :user_id, :created_at, :updated_at, :completed_at, :payment_total,
        :shipment_state, :payment_state, :email, :special_instructions, :channel,
        :included_tax_total, :additional_tax_total, :display_included_tax_total,
        :display_additional_tax_total, :tax_total, :currency, :considered_risky,
        :created_by_id, :canceler_id, :store_id, :group_state, :sale_total, :order_type
      ]

      #   price：实收价格   sale_price：应收价格, label_icon_name: 标签图标
      @@line_item_attributes = [:id, :quantity, :price, :variant_id, :group_number,
        :group_position, :worker_id, :work_at, :cname, :memo, :sale_unit_price, :state,
        :discount_percent, :card_id, :order_id, :label_icon_name, :group_id]

      @@line_item_group_attributes = [:id, :store_id, :order_id, :number, :price, :state, :name, :payment_state, :created_at, :updated_at]

      @@option_type_attributes = [:id, :name, :presentation, :position]

      @@payment_attributes = [
        :id, :source_type, :source_id, :amount, :display_amount,
        :payment_method_id, :state, :avs_response, :created_at,
        :updated_at, :number, :cname
      ]

      @@payment_method_attributes = [:id, :type, :name, :description, :active, :display, :posable]

      @@shipment_attributes = [:id, :tracking, :number, :cost, :shipped_at, :state]

      @@taxonomy_attributes = [:id, :name]

      @@taxon_attributes = [
        :id, :name, :pretty_name, :permalink, :parent_id,
        :taxonomy_id, :meta_title, :meta_description
      ]

      @@inventory_unit_attributes = [
        :id, :lock_version, :state, :variant_id, :shipment_id,
        :return_authorization_id
      ]

      @@return_authorization_attributes = [
        :id, :number, :state, :order_id, :memo, :created_at, :updated_at
      ]

      @@address_attributes = [
        :id, :firstname, :lastname, :full_name, :address1, :address2, :city,
        :zipcode, :phone, :company, :alternative_phone, :country_id, :state_id,
        :state_name, :state_text
      ]

      @@country_attributes = [:id, :iso_name, :iso, :iso3, :name, :numcode]

      @@customer_attributes = [:id, :created_at, :updated_at, :username,
        :mobile, :address, :birth, :memo, :payment_password, :gender,
        :store_id, :number]

      @@state_attributes = [:id, :name, :abbr, :country_id]

      @@adjustment_attributes = [
        :id, :source_type, :source_id, :adjustable_type, :adjustable_id,
        :originator_type, :originator_id, :amount, :label, :mandatory,
        :locked, :eligible, :created_at, :updated_at
      ]

      @@creditcard_attributes = [
        :id, :month, :year, :cc_type, :last_digits, :name,
        :gateway_customer_profile_id, :gateway_payment_profile_id
      ]

      @@payment_source_attributes = [
        :id, :month, :year, :cc_type, :last_digits, :name
      ]

      @@user_attributes = [:id, :email, :created_at, :updated_at, :username, :mobile, :address, :birth, :memo, :payment_password]

      @@user_entry_attributes = [:id, :created_at, :updated_at, :day, :store_id, :user_id, :state]

      @@property_attributes = [:id, :name, :presentation]

      @@stock_location_attributes = [
        :id, :name, :address1, :address2, :city, :state_id, :state_name,
        :country_id, :zipcode, :phone, :active
      ]

      @@stock_movement_attributes = [:id, :day, :memo, :created_by_id, :quantity, :stock_item_id]

      @@stock_item_attributes = [
        :id, :count_on_hand, :backorderable, :lock_version, :stock_location_id,
        :variant_id
      ]

      @@promotion_attributes = [
        :id, :name, :description, :expires_at, :starts_at, :type, :usage_limit,
        :match_policy, :code, :advertise, :path
      ]

      @@store_attributes = [
        :id, :name, :url, :meta_description, :meta_keywords, :seo_title,
        :mail_from_address, :default_currency, :code, :default,
        :doc_printer_name, :receipt_printer_name, :label_printer_name,
        :receipt_title, :receipt_footer, :type, :stock_location_id, :checkout_password_required
      ]

      @@tag_attributes = [:id, :name]

      @@customer_return_attributes = [
        :id, :number, :order_id, :fully_reimbursed?, :pre_tax_total,
        :created_at, :updated_at
      ]

      @@reimbursement_attributes = [
        :id, :reimbursement_status, :customer_return_id, :order_id,
        :number, :total, :created_at, :updated_at
      ]
      @@relation_attributes = [
        :id, :relation_type_id, :relatable_id, :related_to_id, :discount_amount, :discount_percent
      ]
      @@sale_day_attributes = [
        :day, :service_total, :deposit_total, :service_order_count, :new_orders_count, :new_customers_count, :new_cards_count
      ]

      def variant_attributes
        if @current_user_roles && @current_user_roles.include?('admin')
          @@variant_attributes + [:cost_price]
        else
          @@variant_attributes
        end
      end
    end
  end
end
