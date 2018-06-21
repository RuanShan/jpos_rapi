module Spree
  module Api
    module V1
      class CardsController < Spree::Api::BaseController
        before_action :find_card, only: [:update, :transactions]

        def index
          @credit_cards = user.
                          credit_cards.
                          accessible_by(current_ability, :read).
                          with_payment_profile.
                          ransack(params[:q]).result.page(params[:page]).per(params[:per_page])
          respond_with(@credit_cards)
        end

        def update
          if @card
            #authorize! :update, @card
            @card.update_attributes(card_params)
            respond_with(@card, status: 200, default_template: :show)
          else
            invalid_resource!(@card)
          end
        end

        def transactions
          @card_transactions = @card.transactions.reverse_chronological.
            ransack(params[:q]).result.page(params[:page]).per(params[:per_page])
          respond_with(@card_transactions)
        end

        private

        def find_card
          @card = Spree::Card.find_by!(id: params[:id])
        end
        def card_params
          params.require(:card).permit(permitted_card_attributes)
        end

      end
    end
  end
end
