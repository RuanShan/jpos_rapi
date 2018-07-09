module Spree
  module Api
    module V1
      class UserEntriesController < Spree::Api::BaseController
        before_action :get_user_entry, except: [:index, :create]

        def index
          authorize! :read, UserEntry
          @q = UserEntry.ransack(params[:q]).result
          @total_count = @q.count

          @user_entries = @q.includes( :user ).page(params[:page]).per(params[:per_page])

          respond_with(@user_entries)
        end

        def create
          authorize! :create, UserEntry
          @user_entry = UserEntry.new(user_entry_params)
          @user_entry.code = params[:user_entry][:code]
          if @user_entry.save
            respond_with(@user_entry, status: 201, default_template: :show)
          else
            invalid_resource!(@user_entry)
          end
        end

        def update
          authorize! :update, @user_entry
          if @user_entry.update_attributes(user_entry_params)
            respond_with(@user_entry, status: 200, default_template: :show)
          else
            invalid_resource!(@user_entry)
          end
        end

        def show
          authorize! :read, @user_entry
          respond_with(@user_entry)
        end

        def destroy
          authorize! :destroy, @user_entry
          @user_entry.destroy
          respond_with(@user_entry, status: 204)
        end

        private

        def get_user_entry
          @user_entry = UserEntry.find(params[:id])
        end

        def user_entry_params
          params.require(:user_entry).permit(permitted_user_entry_attributes)
        end
      end
    end
  end
end
