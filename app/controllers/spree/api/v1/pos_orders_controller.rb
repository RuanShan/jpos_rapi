module Spree
  module Api
    module V1
      class PosOrdersController < OrdersController
        skip_before_action :authenticate_user, only: :apply_coupon_code

        before_action :find_order, except: [:create, :mine, :current, :index, :update, :all_step, :count, :find_by_group_number]

        def create
          authorize! :create, Spree::Order

          # enable group_state
          order_attributes = params.require(:order).permit(permitted_checkout_attributes)
          #order_attributes[:user] = current_api_user
          order_attributes[:store] = current_store
          order_attributes[:channel] = 'pos'
          @order = Spree::Order.create!(order_attributes)

          if @order.contents.update_cart(order_params)
            @order.complete_via_pos
            respond_with(@order, default_template: :show, status: 201)
          else
            invalid_resource!(@order)
          end

        end

        def empty
          authorize! :update, @order, order_token
          @order.empty!
          render plain: nil, status: 204
        end

        def index
          authorize! :index, Order
          @q = Order.ransack(params[:q]).result
          @total_count = @q.count
          # 订单列表需要显示订单 物品和活的信息
          @orders = @q.includes( :creator, :line_item_groups, :payments, user: :cards, line_items: :variant ).page(params[:page]).per(params[:per_page])
          respond_with(@orders)
        end

        # 基于index的查询条件，统计订单数量和金额
        def count
          @q = Order.ransack(params[:q]).result
          @total_count = @q.count
          @total_sum = @q.sum(:total)
        end

        def show
          authorize! :show, @order, order_token
          respond_with(@order)
        end


        def update
          find_order(true)
          authorize! :update, @order, order_token

          if @order.contents.update_cart(order_params)
            user_id = params[:order][:user_id]
            if current_api_user.has_spree_role?('admin') && user_id
              @order.associate_user!(Spree.user_class.find(user_id))
            end
            respond_with(@order, default_template: :show)
          else
            invalid_resource!(@order)
          end
        end

        ########################################################################
        # for POS
        ########################################################################

        def find_by_group_number
          @line_item_group = Spree::LineItemGroup.find_by!(number: params[:group_number])
          @order = @line_item_group.order
          respond_with(@order, default_template: :show)
        end

        def by_number
          @order = Spree::Order.find_by!(number: params[:number])
          respond_with(@order, default_template: :show)
        end

        def all_step
          authorize! :index, Order
          pos_order_numbers = params[:order_numbers]
          forward = params[:forward].nil? || !!params[:forward]

          @orders = Order.where number: pos_order_numbers
          @orders.each{ |order|
            order.one_step!(forward)
          }

          respond_with(@orders)
        end
        #订单的下一步流程
        def one_step
          find_order(true)
          authorize! :update, @order, order_token
          forward = params[:forward].blank? || !!params[:forward]

          @order.one_step!(forward)
          respond_with(@order, default_template: :show)

        end

        def current
          @order = find_current_order
          if @order
            respond_with(@order, default_template: :show, locals: { root_object: @order })
          else
            head :no_content
          end
        end


        # count order on param states
        # states - is an array of state
        # 参数： store_id,计算这个店铺的订单统计
        #
        def state_counts
          @state_counts = {}
          Order::GROUP_STATES.each{|state|
            @state_counts[state] = Order.where( group_state: state ).count
          }
          @state_counts
        end

        def mine
          if current_api_user.persisted?
            @orders = current_api_user.orders.reverse_chronological.ransack(params[:q]).result.page(params[:page]).per(params[:per_page])
          else
            render 'spree/api/errors/unauthorized', status: :unauthorized
          end
        end

        def apply_coupon_code
          find_order
          authorize! :update, @order, order_token
          @order.coupon_code = params[:coupon_code]
          @handler = PromotionHandler::Coupon.new(@order).apply
          status = @handler.successful? ? 200 : 422
          render 'spree/api/v1/promotions/handler', status: status
        end

        private

        def order_params
          if params[:order]
            normalize_params
            params.require(:order).permit(permitted_order_attributes)
          else
            {}
          end
        end

        def normalize_params
          params[:order][:payments_attributes] = params[:order].delete(:payments) if params[:order][:payments]
          params[:order][:shipments_attributes] = params[:order].delete(:shipments) if params[:order][:shipments]
          params[:order][:line_items_attributes] = params[:order].delete(:line_items) if params[:order][:line_items]
          params[:order][:ship_address_attributes] = params[:order].delete(:ship_address) if params[:order][:ship_address]
          params[:order][:bill_address_attributes] = params[:order].delete(:bill_address) if params[:order][:bill_address]
        end

        def find_order(lock = false)
          @order = Spree::Order.lock(lock).find_by!(id: params[:id])
        end

        def find_current_order
          current_api_user ? current_api_user.orders.incomplete.order(:created_at).last : nil
        end

        def order_id
          super || params[:id]
        end
      end
    end
  end
end
