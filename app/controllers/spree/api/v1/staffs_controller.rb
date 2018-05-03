module Spree
  module Api
    module V1
      class StaffsController < UsersController
        rescue_from Spree::Core::DestroyWithOrdersError, with: :error_during_processing

        def index
          @users = Staff.accessible_by(current_ability, :read)

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


      end
    end
  end
end
