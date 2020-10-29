module Spree
  module Api
    module V1
      class LineItemGroupsController < Spree::Api::BaseController
        before_action :fine_line_item_group, only: [:one_step, :show, :cancel, :rework]

        def index
          authorize! :index, LineItemGroup
          fixRansackQuery()
          @q = line_item_group_scope.ransack(params[:q]).result(distinct: true)
          #Rails.logger.debug "@q=#{LineItemGroup.reverse_chronological.ransack(params[:q]).inspect}"
          @total_count = @q.count
          @line_item_groups = @q.includes(:order, :line_items, :images ).page(params[:page]).per(params[:per_page])
          respond_with(@line_item_groups)
        end

        # 扫码时访问，由于条码不包括年份，可能会重复，添加默认条件，没有取走的物品，即状态补位completed的物品
        #
        def show
          basescope = Spree::LineItemGroup.accessible_by(current_ability, :update).readonly(false).inprogress

          @line_item_group = basescope.find_by!(number: params[:id])
          
          respond_with(@line_item_group, default_template: :show)
        end

        # 只修改订单中一个商品的流程
        #
        def one_step
          forward = params[:forward].blank? || !!params[:forward]
          @line_item_group.make_step_and_order forward

          respond_with(@line_item_group, default_template: :show)
        end

        #
        # params: state - 快速转移到参数状态，用于没有工厂情况，物品直接到“带交付”状态
        def all_step

          numbers = params[:numbers]
          ids = params[:ids]
          state = params[:state]
          forward = params[:forward].nil? || !!params[:forward]
          if ids.present?
            @line_item_groups = Spree::LineItemGroup.where id: ids
          else
            @line_item_groups = Spree::LineItemGroup.where number: numbers
          end
          @line_item_groups.each{ |group|
            if state.present?
              group.quick_move( state )
            else
              group.make_step_and_order forward
            end
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
          @line_item_group.update_attributes(line_item_group_params)

          respond_with(@line_item_group.reload, default_template: :show)
        end

        # 查询店铺的数据
        # states - is an array of state
        def counts
          # 如果 params[:q] 为空，需要加上店铺条件 in
          fixRansackQuery()
          
          @q = LineItemGroup.ransack(params[:q]).result

          @counts = {}
          Order::GROUP_STATES.each{|state|
            @counts[state] = @q.where( state: state ).count
          }
          @counts
        end

 
        #物品订单取消
        def cancel
          @line_item_group.canceled_by(current_api_user)
          #update returned_memo
          @line_item_group.update_attributes(line_item_group_params)

          respond_with(@line_item_group, default_template: :show)
        end

        #物品订单返工
        def rework
          @line_item_group.returned_by(current_api_user)

          @line_item_group.update_attributes(line_item_group_params)

          respond_with(@line_item_group, default_template: :show)
        end

        private

        def fine_line_item_group

          @line_item_group = Spree::LineItemGroup.accessible_by(current_ability, :update).readonly(false).find_by!(number: params[:id])
        end

        def line_item_group_scope

            scope = Spree::LineItemGroup.accessible_by(current_ability, :read).includes(:order)
            scope = scope.where( {spree_orders:{state: :cart}} )
            scope = scope.reverse_chronological

        end

        def line_item_group_params
          params.require(:line_item_group).permit(permitted_line_item_group_attributes)
        end


      end
    end
  end
end
