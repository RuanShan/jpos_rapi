module Spree
  module Api
    module V1
      class CustomersController < UsersController

        def index
          fixRansackQuery()

          @customers = Customer.accessible_by(current_ability, :read)
          @customers = @customers.includes(:cards,:wx_follower)
          @customers = if params[:ids]
                     @customers.ransack(id_in: params[:ids].split(','))
                   else
                     @customers.ransack(params[:q])
                   end
          @q = @customers.result(distinct: true)
          @total_count = @q.count
          @customers = @q.page(params[:page]).per(params[:per_page])
          expires_in 15.minutes, public: true
          headers['Surrogate-Control'] = "max-age=#{15.minutes}"
          respond_with(@customers)
        end

        def create

          @customer = Customer.new(user_params) do|user|
            user.creator = current_api_user
          end
          if @customer.save
            if params[:order].present?
              order_attributes = deposit_order_params( @customer )
              @order = Spree::Order.create!(order_attributes)
              @order.complete_via_pos
            end
            respond_with(@customer, status: 201, default_template: :show)
          else
            invalid_resource!(@customer)
          end
        end

        def statis
          @customer = user
          orderids = @customer.orders.type_normal.pluck(:id)
          @statis = { order_total: 0, normal_order_total: 0, card_order_total: 0, nocard_order_total: 0 }
          @statis[:normal_order_total] = @customer.orders.type_normal.sum(:payment_total)
          @statis[:card_order_total] = @customer.orders.type_card.sum(:payment_total)
          # @statis[:nocard_order_total] = @customer.orders.type_normal.includes(:payments).
          #    where( spree_payments: {  state: 'completed', source_type: nil}).
          #    sum(:payment_total)

          @statis[:nocard_order_total] = Spree::Payment.completed.where( {order_id: orderids, source_type: nil }).sum(:amount)
        end

        # params
        #   mobile: reqired, new mobile to validate
        #   id: optional, except id of customer
        def validate_mobile
          mobile = params[:mobile]
          id = params[:id]
          valid_mobile = !!( mobile =~/^1\d{10}$/ )
          if valid_mobile
            if id.present?
              valid_mobile = !customer_default_scope.where.not(id: id).exists?( mobile: mobile )
            else
              valid_mobile = !customer_default_scope.exists?( mobile: mobile )
            end
          end
          json = { ret: valid_mobile }
          render json: json
        end

        def discard_wxfollower
          ret = false
          @customer = user
          if @customer.wx_follower.present?
            @wx_follower = @customer.wx_follower
            @wx_follower.customer_id= nil
            ret = @wx_follower.save
          end
          json = { ret: ret }
          render json: json
        end

        def send_sms
          @customer_scope = Customer.accessible_by(current_ability, :read)
          @customers = @customer_scope.find(  params[:ids].split(','))
          mobiles = @customers.map(&:mobile).join(',')
          template_code = params[:template_code]
          ret = SmsService.sendto( mobiles, template_code )
          render json: { ret: ret}
        end

        private
        def user
          @customer ||= Customer.accessible_by(current_ability, :read).find(params[:id])
        end

        def user_params
          permitted_params= params.require(:user).permit(permitted_customer_attributes |
                                         [cards_attributes: permitted_card_attributes])

          if permitted_params[:cards_attributes]
            permitted_params[:cards_attributes].each{|card|  card[:created_by_id] = current_api_user.id }
          end
          permitted_params

        end

        def deposit_order_params( user  )
          card = user.cards.first
          params[:order][:payments_attributes] = params[:order].delete(:payments) if params[:order][:payments]

          amount = params[:order][:payments_attributes].inject(0){ |sum,payment| sum + payment[:amount].to_i  }
          params[:order][:line_items_attributes] ||= [{variant_id: card.variant_id, price: amount, quantity: 1}]
          params[:order][:line_items_attributes][0][:card_id] = card.id

          permitted_params = params.require(:order).permit(permitted_order_attributes)

          permitted_params[:channel] = 'pos'
          #get store from client
          #permitted_params[:store] = current_store
          permitted_params[:user] = user
          permitted_params[:creator] = current_api_user
          permitted_params[:order_type] = :card
          permitted_params[:payment_at] = DateTime.current

          permitted_params
        end

        def customer_default_scope
          Customer.where( store: Spree::Site.current.stores )
        end
      end
    end
  end
end
