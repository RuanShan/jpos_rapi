module Spree
  module Api
    module V1
      class CustomersController < UsersController

        def index
          @customers = Customer.accessible_by(current_ability, :read)

          @customers = if params[:ids]
                     @customers.ransack(id_in: params[:ids].split(','))
                   else
                     @customers.ransack(params[:q])
                   end
          @q = @customers.result
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
            end
            respond_with(@customer, status: 201, default_template: :show)
          else
            invalid_resource!(@customer)
          end
        end

        def statis
          @customer = user
          @statis = { order_total: 0, normal_order_total: 0, card_order_total: 0 }
          @statis[:normal_order_total] = @customer.orders.type_normal.sum(:total)
          @statis[:card_order_total] = @customer.orders.type_card.sum(:total)

        end

        # params
        #   mobile: reqired, new mobile to validate
        #   id: optional, except id of customer
        def validate_mobile
          mobile = params[:mobile]
          id = params[:id]
          valid_mobile = !!( mobile =~/^1[3,4,5,7,8]\d{9}$/ )
          if valid_mobile
            if id.present?
              valid_mobile = !Customer.where.not(id: id).exists?( mobile: mobile )
            else
              valid_mobile = !Customer.exists?( mobile: mobile )
            end
          end
          json = { result: valid_mobile }
          render json: json
        end

        private
        def user
          @customer ||= Customer.accessible_by(current_ability, :read).find(params[:id])
        end

        def user_params
          params.require(:user).permit(permitted_customer_attributes |
                                         [cards_attributes: permitted_card_attributes])
        end

        def deposit_order_params( user  )
          card = user.cards.first
          params[:order][:payments_attributes] = params[:order].delete(:payments) if params[:order][:payments]

          amount = params[:order][:payments_attributes].inject(0){ |sum,payment| sum + payment[:amount].to_i  }
          params[:order][:line_items_attributes] = [{variant_id: card.variant_id, price: amount}]
          params[:order][:line_items_attributes][0][:card_id] = card.id

          permitted_params = params.require(:order).permit(permitted_order_attributes)

          permitted_params[:channel] = 'pos'
          permitted_params[:store] = current_store
          permitted_params[:user] = user
          permitted_params[:creator] = current_api_user
          permitted_params[:order_type] = :card

          permitted_params
        end
      end
    end
  end
end
