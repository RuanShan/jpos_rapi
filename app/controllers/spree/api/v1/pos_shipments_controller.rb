module Spree
  module Api
    module V1
      class PosShipmentsController < Spree::Api::BaseController
        before_action :find_and_update_shipment, only: [:ship, :ready, :add, :remove]

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


        def find_and_update_shipment
          @shipment = Spree::Shipment.accessible_by(current_ability, :update).readonly(false).find_by!(number: params[:id])
          @shipment.update_attributes(shipment_params)
          @shipment.reload
        end

        def shipment_params
          if params[:shipment] && !params[:shipment].empty?
            params.require(:shipment).permit(permitted_shipment_attributes)
          else
            {}
          end
        end

        def variant
          @variant ||= Spree::Variant.unscoped.find(params.fetch(:variant_id))
        end

        def mine_includes
          {
            order: {
              bill_address: {
                state: {},
                country: {},
              },
              ship_address: {
                state: {},
                country: {},
              },
              adjustments: {},
              payments: {
                order: {},
                payment_method: {},
              },
            },
            inventory_units: {
              line_item: {
                product: {},
                variant: {},
              },
              variant: {
                product: {},
                default_price: {},
                option_values: {
                  option_type: {},
                },
              },
            },
          }
        end
      end
    end
  end
end
