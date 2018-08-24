module Spree
  module Api
    module V1
      class ExpensesController < Spree::Api::BaseController
        before_action :find_expense, only: [:show, :update, :destroy]

        def index
          @expenses = Selling::Expense.accessible_by(current_ability, :read)

          @expenses = if params[:ids]
                          @expenses.where(id: params[:ids].split(',').flatten)
                        else
                          @expenses.ransack(params[:q]).result
                        end

          @expenses = @expenses.page(params[:page]).per(params[:per_page])
          respond_with(@expenses)
        end

        def show
          respond_with(@expense)
        end

        def new; end

        def create
          authorize! :create, ExpenseItem
          @expense = Selling::Expense.new(expense_params)
          if @expense.save
            respond_with(@expense, status: 201, default_template: :show)
          else
            invalid_resource!(@expense)
          end
        end

        def update
          if @expense
            authorize! :update, @expense
            @expense.update_attributes(expense_params)
            respond_with(@expense, status: 200, default_template: :show)
          else
            invalid_resource!(@expense)
          end
        end

        def destroy
          if @expense
            authorize! :destroy, @expense
            @expense.destroy
            respond_with(@expense, status: 204)
          else
            invalid_resource!(@expense)
          end
        end

        private

        def find_expense
          @expense = Selling::Expense.accessible_by(current_ability, :read).find(params[:id])
        rescue ActiveRecord::RecordNotFound
          @expense = Selling::Expense.accessible_by(current_ability, :read).find_by!(name: params[:id])
        end

        def expense_params
          params.require(:expense).permit(permitted_expense_attributes)
        end
      end
    end
  end
end
