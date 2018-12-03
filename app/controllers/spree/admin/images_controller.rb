module Spree
  module Admin
    class ImagesController < ResourceController
      helper_method :get_belongs_to_name

      before_action :load_edit_data, except: :index
      before_action :load_index_data, only: :index

      create.before :set_viewable
      update.before :set_viewable

      private

      def load_index_data
        @product = Product.friendly.includes(*variant_index_includes).find(get_belongs_to_id)
      end

      def load_edit_data
        @product = Product.friendly.includes(*variant_edit_includes).find(get_belongs_to_id)
        @variants = @product.variants.map do |variant|
          [variant.sku_and_options_text, variant.id]
        end
        @variants.insert(0, [Spree.t(:all), @product.master.id])
      end

      def set_viewable
        @image.viewable_type = 'Spree::Variant'
        @image.viewable_id = params[:image][:viewable_id]
      end

      def variant_index_includes
        [
          variant_images: [viewable: { option_values: :option_type }]
        ]
      end

      def variant_edit_includes
        [
          variants_including_master: { option_values: :option_type, images: :viewable }
        ]
      end

      def new_object_url( options={} )
        spree.new_polymorphic_url([:admin, @product, model_class], options)
      end

      def collection_url(options = {})
        spree.polymorphic_url([:admin, @product, model_class], options)
      end

      def get_belongs_to_id
        params[:product_id] || params[:selling_service_id] || params[:selling_prepaid_card_id] || params[:selling_counter_id]
      end

      def get_belongs_to_name
        @product.class.name.underscore.sub('/','_')
      end

    end
  end
end
