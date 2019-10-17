module Spree
  module Api
    module V1
      class ExpenseItemsController < Spree::Api::BaseController
        before_action :find_expense_item, only: [:show, :update, :destroy]

        def index
          @expense_items = Spree::ExpenseItem.accessible_by(current_ability, :read)

          @q = @expense_items.ransack(params[:q]).result( distinct: true)
          @total_count = @q.count
          @total_sum = @q.sum(:price).to_i

          @expense_items = @q.includes([:store, :user, :images]).page(params[:page]).per(params[:per_page])
          respond_with(@expense_items)
        end

        def show
          respond_with(@expense_item)
        end

        def new; end

        def create
          authorize! :create, ExpenseItem
          @expense_item = Spree::ExpenseItem.new(expense_item_params)
          if @expense_item.save
            respond_with(@expense_item, status: 201, default_template: :show)
          else
            invalid_resource!(@expense_item)
          end
        end

        def update
          if @expense_item
            authorize! :update, @expense_item
            @expense_item.update_attributes(expense_item_params)
            respond_with(@expense_item, status: 200, default_template: :show)
          else
            invalid_resource!(@expense_item)
          end
        end

        def destroy
          if @expense_item
            authorize! :destroy, @expense_item
            @expense_item.destroy
            respond_with(@expense_item, status: 204)
          else
            invalid_resource!(@expense_item)
          end
        end

        private

        def find_expense_item
          @expense_item = Spree::ExpenseItem.accessible_by(current_ability, :read).find(params[:id])
        rescue ActiveRecord::RecordNotFound
          @expense_item = Spree::ExpenseItem.accessible_by(current_ability, :read).find_by!(name: params[:id])
        end

        def expense_item_params
          params.require(:expense_item).permit(permitted_expense_item_attributes)
        end
      end
    end
  end
end
