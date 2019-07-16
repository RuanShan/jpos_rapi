module Spree
  module Api
    module V1
      class CardsController < Spree::Api::BaseController
        before_action :find_card, only: [ :show, :replace, :update, :transactions, :send_password_sms, :get_discounts]

        def index
          @cards = user.
                          cards.
                          accessible_by(current_ability, :read).
                          ransack(params[:q]).result.page(params[:page]).per(params[:per_page])
          respond_with(@cards)
        end

        def update
          if @card
            authorize! :update, @card
            permitted_card_params = card_params
            state = permitted_card_params.delete :state
            # 单独调用，以便更新后生成state_changes
            if state == 'enabled'
              @card.enable
            elsif state == 'disabled'
              @card.disable
            end

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
        def code_available
          code = params[:code]
          exist = Spree::Card.exists?( code: code )
          json = { ret: !exist }
          render json: json
        end

        # 检查payment_password是否可用
        # 参数
        #  id
        #  payment_password
        def validate_password
          payment_password = params[:payment_password]
          id = params[:id]

          valid  = Spree::Card.where(id: id).exists?( payment_password: payment_password )

          json = { ret: valid }
          render json: json
        end

        # 发送会员卡密码到会员手机
        # 参数
        #    id
        def send_password_sms
          @customer = @card.customer

          success = SmsService.send_password( @customer.mobile, @card.payment_password )
          json = { ret: success }
          render json: json

        end

        # compute variant price for current card
        # params
        #   variant_id
        #   variant_ids
        # return
        #   { variant_id: discount_percent, "pid"+product_id: discount_percent}
        #   ex. { "17": 70,    "20": 70 }

        def get_discounts
          @selling_card = @card.variant.product
          @relation_type = @selling_card.relation_types.first
          @variants = Spree::Variant.includes(:product).find( params[:variant_ids] )
          @vid_product_hash = @variants.reduce({}){|memo, v|
            memo[v.id] = v.product
            memo
          }
          @discounts = { }

          if @vid_product_hash.present? && @relation_type.present?
            @vid_product_hash.each_pair{| vid, product|
              @relation_type.relations.each{| relation |
                if relation.related_to_id == product.id
                  @discounts[vid] = relation.discount_percent
                  @discounts["pid#{product.id}"] = relation.discount_percent
                  break
                end
              }
            }
          end

          render json: @discounts

        end

        def show
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
