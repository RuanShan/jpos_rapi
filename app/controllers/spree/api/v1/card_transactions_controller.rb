module Spree
  module Api
    module V1
      class CardTransactionsController < Spree::Api::BaseController
        before_action :find_card_transaction, only: [:update]

        def index
          @q = Spree::CardTransaction.ransack(params[:q]).result
          @total_count = @q.count

          @card_transactions = @q.includes(:card, order: :line_items).page(params[:page]).per(params[:per_page])
          respond_with(@card_transactions)
        end

        def update
          if @card_transaction
            #authorize! :update, @card
            @card_transaction.update_attributes(card_params)
            respond_with(@card_transaction, status: 200, default_template: :show)
          else
            invalid_resource!(@card_transaction)
          end
        end


        private

        def find_card_transaction
          @card_transaction = Spree::CardTransaction.find_by!(id: params[:id])
        end
        def card_transaction_params
          params.require(:card_transaction).permit(permitted_card_transaction_attributes)
        end

      end
    end
  end
end
