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
              order_attributes = card_params( @user )
              @order = Spree::Order.create!(order_attributes)
            end
            respond_with(@user, status: 201, default_template: :show)
          else
            invalid_resource!(@user)
          end
        end

        def validate_mobile
          mobile = params[:mobile]
          valid_mobile = !!( mobile =~/^1[3,4,5,7,8]\d{9}$/ )
          if valid_mobile
            valid_mobile = !( User.exists?( mobile: mobile ) )
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
                                         [bill_address_attributes: permitted_address_attributes,
                                          ship_address_attributes: permitted_address_attributes])
        end

        def card_params( user  )
          params[:order][:payments_attributes] = params[:order].delete(:payments) if params[:order][:payments]
          params[:order][:line_items_attributes] = params[:order].delete(:line_items) if params[:order][:line_items]

          permitted_params = params.require(:order).permit(permitted_order_attributes)

          permitted_params[:channel] = 'pos'
          permitted_params[:store] = current_store
          permitted_params[:user] = user
          permitted_params[:created_by] = current_api_user
          permitted_params
        end
      end
    end
  end
end
