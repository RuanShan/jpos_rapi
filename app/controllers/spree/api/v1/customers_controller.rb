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
            respond_with(@user, status: 201, default_template: :show)
          else
            invalid_resource!(@user)
          end
        end


        private
        def user
          @user ||= Customer.accessible_by(current_ability, :read).find(params[:id])
        end

      end
    end
  end
end
