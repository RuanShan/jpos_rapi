module Spree
  module Api
    module V1
      class PosOrdersController < OrdersController
        skip_before_action :authenticate_user, only: :apply_coupon_code

        before_action :find_order, except: [:create, :mine, :current, :index, :update, :all_step, :count, :find_by_group_number]


        def create
          authorize! :create, Spree::Order

          # enable group_state
          order_attributes = order_params
          order_attributes[:creator] = current_api_user
          # get store_id from client
          # order_attributes[:store] = current_store
          order_attributes[:channel] = 'pos'
          @order = Spree::Order.new(order_attributes)
          if @order.save
            @order.complete_via_pos
            # update card other attributes
            if @order.order_type_card_or_deposit? && params[:card].present?
              permitted_card_params = card_params
              code = permitted_card_params.delete :code
              card = Spree::Card.find_by( code: code ).update_attributes( permitted_card_params )
            end
            respond_with(@order, default_template: :show, status: 201)
          else
            invalid_resource!(@order)
          end

        end


        def cancel
          @order.canceled_by(current_api_user)
          respond_with(@order, default_template: :show)
        end


        def empty
          authorize! :update, @order, order_token
          @order.empty!
          render plain: nil, status: 204
        end

        def index
          #authorize! :index, Order
          @q = Order.ransack(params[:q]).result(distinct: true)
          @total_count = @q.count
          # 订单列表需要显示订单 物品和活的信息
          @orders = @q.includes( :creator, :payments, user: :cards, line_item_groups: :images, line_items: :variant ).page(params[:page]).per(params[:per_page])
          respond_with(@orders)
        end

        # 基于index的查询条件，统计订单数量和金额
        def count
          @q = Order.ransack(params[:q]).result(distinct: true)
          @total_count = @q.count
          @total_sum = @q.sum(:total)
        end

        def show
          #authorize! :show, @order, order_token
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
        #后付款时，添加支付方式, 支付为数组
        # params
        #  line_item_ids: []
        #  payments: []
        def add_payments
          line_item_ids = params[:line_item_ids]
          @order.validate_payments_attributes(payments_params)
          @payments = @order.payments.build( payments_params )
          saved = []
          Spree::Payment.transaction do
            saved = @payments.each( &:save).map( &:capture!)
          end
          Rails.logger.debug "saved=#{saved.inspect} "
          line_items = Spree::LineItem.find( line_item_ids )
          line_items.each{|item|
            item.line_item_group.update_attribute( :payment_state, :paid ) if item.line_item_group
          }
          if saved.present?
            respond_with(@payments, status: 201)
          else
            head :no_content
          end
        end

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

        def destroy
          authorize! :destroy, @order
          @order.destroy
          respond_with(@order, status: 204)
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

        def payments_params
          required_params = params.require(:payments)
          required_params.map{|attrs|
            attrs.permit(permitted_payment_attributes)
          }
        end

        def card_params
          params.require(:card).permit(permitted_card_attributes)
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
