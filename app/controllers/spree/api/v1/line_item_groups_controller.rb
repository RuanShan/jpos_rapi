module Spree
  module Api
    module V1
      class LineItemGroupsController < Spree::Api::BaseController
        before_action :fine_line_item_group, only: [:one_step, :show]


        def show
          @line_item_group = Spree::LineItemGroup.accessible_by(current_ability, :read).includes(mine_includes).find_by!(number: params[:id])

          respond_with(@line_item_group, default_template: :show)
        end

        # 只修改订单中一个商品的流程
        #
        def one_step
          forward = params[:forward].blank? || !!params[:forward]
          @line_item_group.make_step_and_order forward

          respond_with(@line_item_group, default_template: :show)
        end

        def update
          @line_item_group = Spree::LineItemGroup.accessible_by(current_ability, :update).readonly(false).find_by!(number: params[:id])
          @line_item_group.update_attributes_and_order(shipment_params)

          respond_with(@line_item_group.reload, default_template: :show)
        end


        private

        def fine_line_item_group
          @line_item_group = Spree::LineItemGroup.accessible_by(current_ability, :update).readonly(false).find_by!(number: params[:id])
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
