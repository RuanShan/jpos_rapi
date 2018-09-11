module Spree
  module Api
    module V1
      class ExpenseCategoriesController < Spree::Api::BaseController
        before_action :get_expense_category, except: [:index, :create]

        def index
          authorize! :read, ExpenseCategory
          @expense_categories = ExpenseCategory.accessible_by(current_ability, :read).all
          respond_with(@expense_categories)
        end

        def create
          authorize! :create, ExpenseCategory
          @expense_category = ExpenseCategory.new(expense_category_params)
          @expense_category.code = params[:expense_category][:code]
          if @expense_category.save
            respond_with(@expense_category, status: 201, default_template: :show)
          else
            invalid_resource!(@expense_category)
          end
        end

        def update
          authorize! :update, @expense_category
          if @expense_category.update_attributes(expense_category_params)
            respond_with(@expense_category, status: 200, default_template: :show)
          else
            invalid_resource!(@expense_category)
          end
        end

        def show
          authorize! :read, @expense_category
          respond_with(@expense_category)
        end

        def destroy
          authorize! :destroy, @expense_category
          @expense_category.destroy
          respond_with(@expense_category, status: 204)
        end

        private

        def get_expense_category
          @expense_category = ExpenseCategory.find(params[:id])
        end

        def expense_category_params
          params.require(:expense_category).permit(permitted_expense_category_attributes)
        end
      end
    end
  end
end
