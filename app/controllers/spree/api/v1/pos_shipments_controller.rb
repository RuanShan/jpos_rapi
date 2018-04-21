module Spree
  module Api
    module V1
      class PosShipmentsController < ShipmentsController
        before_action :find_shipment, only: [:show]


        def show
          @shipment = Spree::Shipment.accessible_by(current_ability, :read).includes(mine_includes).find_by!(number: params[:id])

          respond_with(@shipment, default_template: :show)
        end

        # 只修改订单中一个商品的流程
        #
        def one_step
          forward = params[:forward].blank? || !!params[:forward]
          @shipment.make_step_and_order forward

          respond_with(@shipment, default_template: :show)
        end

        def update
          @shipment = Spree::Shipment.accessible_by(current_ability, :update).readonly(false).find_by!(number: params[:id])
          @shipment.update_attributes_and_order(shipment_params)

          respond_with(@shipment.reload, default_template: :show)
        end


        private

        def find_shipment
          @shipment = Spree::Shipment.accessible_by(current_ability, :update).readonly(false).find_by!(number: params[:id])
        end

        def variant
          @variant ||= Spree::Variant.unscoped.find(params.fetch(:variant_id))
        end

      end
    end
  end
end
