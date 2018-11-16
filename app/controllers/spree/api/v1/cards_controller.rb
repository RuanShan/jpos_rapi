module Spree
  module Api
    module V1
      class CardsController < Spree::Api::BaseController
        before_action :find_card, only: [:replace, :update, :transactions]

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

        # 由于用户丢失或其他原因，需要更换新卡，或更换到其他卡，
        # 即将当前卡的余额转入到目标卡
        # params
        #    id: 原卡id
        #    target_code：目标卡号，目标卡可能是新卡或者已经存在的卡。
        def replace
          card = @card.dup
          target_code = params[:target_code]
          target_card = Spree::Card.where(code: target_code).first
          if target_card.blank?
            target_card = Spree::Card.create( card.attributes.merge({ code: target_code}))
          end
          @card.replace_with( target_card )
          @cards = [@card, target_card]
          respond_with @cards
        end

        # 参数
        #   code-检验code是否可用，没有使用过
        def is_code_available
          code = params[:code]
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
