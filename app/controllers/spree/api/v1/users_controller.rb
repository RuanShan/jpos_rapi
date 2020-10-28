module Spree
  module Api
    module V1
      class UsersController < Spree::Api::BaseController
        rescue_from Spree::Core::DestroyWithOrdersError, with: :error_during_processing

        def index
          fixRansackQuery()

          @users = Spree.user_class.accessible_by(current_ability, :read)

          @users = if params[:ids]
                     @users.ransack(id_in: params[:ids].split(','))
                   else
                     @users.ransack(params[:q])
                   end

          @users = @users.result(distinct: true).page(params[:page]).per(params[:per_page])
          expires_in 15.minutes, public: true
          headers['Surrogate-Control'] = "max-age=#{15.minutes}"
          respond_with(@users)
        end

        # 这个方法无法正确工作，用户会按条件查询，但是关联的user_entries会查询到所有的。
        # 参数: eq:{ day_gteq:'2018-07-06',day_lteq:'2018-07-06'}， 必须
        #
        def entries

          eq = params.require(:eq).to_unsafe_hash
          uq = eq.inject({}){|h, pair| h["user_entries_#{pair[0]}"] = pair[1]; h}
          #Rails.logger.debug " eq=#{eq.inspect}, uq=#{uq.inspect}"
          if uq['store_id_eq'].blank?
            uq['store_id_in'] = Spree::Site.current.store_ids
          end  

          @uq = User.ransack(uq).result( distinct: true )
          @total_count = @uq.count
          @users =@uq.page(params[:page]).per(params[:per_page])

          @eq = UserEntry.ransack(eq).result( distinct: true )
          @user_entries =@eq
          @users.each{|user|
            user.searched_entries= @user_entries.select{|entry| entry.user_id == user.id}
            Rails.logger.debug "user.searched_entries=#{user.searched_entries.inspect} "
          }
          Rails.logger.debug "@user_entries=#{@user_entries.inspect} "
          respond_with(@users)
        end


        def show
          respond_with(user)
        end

        def new; end

        def create
          authorize! :create, Spree.user_class
          @user = Spree.user_class.new(user_params) do|user|
            user.creator = current_api_user
          end
          if @user.save
            respond_with(@user, status: 201, default_template: :show)
          else
            invalid_resource!(@user)
          end
        end

        def update
          authorize! :update, user
          if user.update_attributes(user_params)
            respond_with(user, status: 200, default_template: :show)
          else
            invalid_resource!(user)
          end
        end

        def destroy
          authorize! :destroy, user
          user.destroy
          respond_with(user, status: 204)
        end

        def cards
          authorize! :read, user
          @cards = user.cards

        end

        private

        def user
          @user ||= Spree.user_class.accessible_by(current_ability, :read).find(params[:id])
        end

        def user_params
          params.require(:user).permit(permitted_user_attributes |
                                         [bill_address_attributes: permitted_address_attributes,
                                          ship_address_attributes: permitted_address_attributes])
        end
      end
    end
  end
end
