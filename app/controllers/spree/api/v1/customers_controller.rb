module Spree
  module Api
    module V1
      class CustomersController < UsersController

        def index
          @users = Customer.accessible_by(current_ability, :read)

          @users = if params[:ids]
                     @users.ransack(id_in: params[:ids].split(','))
                   else
                     @users.ransack(params[:q])
                   end
          @q = @users.result
          @total_count = @q.count
          @users = @q.page(params[:page]).per(params[:per_page])
          expires_in 15.minutes, public: true
          headers['Surrogate-Control'] = "max-age=#{15.minutes}"
          respond_with(@users)
        end

        def create

          @user = Customer.new(user_params) do|user|
            user.created_by = current_api_user
          end
          if @user.save
            if params[:order].present?
              order_attributes = deposit_order_params( @user )
              @order = Spree::Order.create!(order_attributes)
            end
            respond_with(@user, status: 201, default_template: :show)
          else
            invalid_resource!(@user)
          end
        end

        def stat
          @user = user
          @statistics = { order_total: 0, normal_order_total: 0, card_order_total: 0 }
          @statistics[:normal_order_total] = @user.orders.type_normal.sum(:total)
          @statistics[:card_order_total] = @user.orders.type_card.sum(:total)

        end

        def validate_mobile
          mobile = params[:mobile]
          valid_mobile = !!( mobile =~/^1[3,4,5,7,8]\d{9}$/ )
          if valid_mobile
            valid_mobile = !Customer.exists?( mobile: mobile )
          end
          json = { result: valid_mobile }
          render json: json
        end

        private
        def user
          @user ||= Customer.accessible_by(current_ability, :read).find(params[:id])
        end

        def user_params
          params.require(:user).permit(permitted_user_attributes |
                                         [cards_attributes: permitted_card_attributes])
        end

        def deposit_order_params( user  )
          card = user.cards.first
          params[:order][:payments_attributes] = params[:order].delete(:payments) if params[:order][:payments]

          amount = params[:order][:payments_attributes].inject(0){ |sum,payment| sum + payment[:amount]  }
          params[:order][:line_items_attributes] = [{variant_id: card.variant_id, price: amount}]
          params[:order][:line_items_attributes][0][:card_id] = card.id

          permitted_params = params.require(:order).permit(permitted_order_attributes)

          permitted_params[:channel] = 'pos'
          permitted_params[:store] = current_store
          permitted_params[:user] = user
          permitted_params[:created_by] = current_api_user
          permitted_params[:order_type] = :new_card

          permitted_params
        end
      end
    end
  end
end
