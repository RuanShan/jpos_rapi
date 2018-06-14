module Spree
  module Api
    module V1
      class LineItemGroupsController < Spree::Api::BaseController
        before_action :fine_line_item_group, only: [:one_step, :show]

        def index
          authorize! :index, LineItemGroup
          @q = LineItemGroup.reverse_chronological.ransack(params[:q]).result
          @total_count = @q.count
          @line_item_groups = @q.includes(:order).page(params[:page]).per(params[:per_page])
          respond_with(@line_item_groups)
        end

        def show
          respond_with(@line_item_group, default_template: :show)
        end

        # 只修改订单中一个商品的流程
        #
        def one_step
          forward = params[:forward].blank? || !!params[:forward]
          @line_item_group.make_step_and_order forward

          respond_with(@line_item_group, default_template: :show)
        end

        def all_step

          numbers = params[:numbers]
          ids = params[:ids]
          forward = params[:forward].nil? || !!params[:forward]
          if ids.present?
            @line_item_groups = Spree::LineItemGroup.where id: ids
          else
            @line_item_groups = Spree::LineItemGroup.where number: numbers
          end
          @line_item_groups.each{ |group|
            group.make_step_and_order forward
          }
          respond_with(@line_item_groups)
        end

        def all_complete
          ids = params[:ids]
          @line_item_groups = Spree::LineItemGroup.where id: ids
          @line_item_groups.each{ |group|
            group.finalize!
          }
          respond_with(@line_item_groups)
        end


        def update
          @line_item_group = Spree::LineItemGroup.accessible_by(current_ability, :update).readonly(false).find_by!(number: params[:id])
          @line_item_group.update_attributes_and_order(shipment_params)

          respond_with(@line_item_group.reload, default_template: :show)
        end

        # count order on param states
        # states - is an array of state
        def counts
          @q = LineItemGroup.ransack(params[:q]).result

          @counts = {}
          Order::GROUP_STATES.each{|state|
            @counts[state] = @q.where( state: state ).count
          }
          @counts
        end

        private

        def fine_line_item_group
          @line_item_group = Spree::LineItemGroup.accessible_by(current_ability, :update).readonly(false).find_by!(number: params[:id])
        end

      end
    end
  end
end
