module Spree
  class PaymentMethod::PrepaidCard < PaymentMethod
    def payment_source_class
      ::Spree::PrepaidCard
    end

    def actions
      %w{capture void}
    end

    def can_void?(payment)
      payment.pending?
    end

    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    def authorize(amount_in_cents, prepaid_card, gateway_options = {})
      if prepaid_card.nil?
        ActiveMerchant::Billing::Response.new(false, Spree.t('prepaid_card_payment_method.unable_to_find'), {}, {})
      else
        action = -> (prepaid_card) do
          prepaid_card.authorize(amount_in_cents / 100.0.to_d, order_number: get_order_number(gateway_options))
        end
        handle_action_call(prepaid_card, action, :authorize)
      end
    end

    def capture(amount_in_cents, auth_code, gateway_options = {})
      action = -> (prepaid_card) do
        prepaid_card.capture(amount_in_cents / 100.0.to_d, auth_code, order_number: get_order_number(gateway_options))
      end
      handle_action(action, :capture, auth_code)
    end

    def void(auth_code, gateway_options = {})
      action = -> (prepaid_card) do
        prepaid_card.void(auth_code, order_number: get_order_number(gateway_options))
      end
      handle_action(action, :void, auth_code)
    end

    def purchase(amount_in_cents, prepaid_card, gateway_options = {})
      if prepaid_card.nil?
        ActiveMerchant::Billing::Response.new(false, Spree.t('prepaid_card_payment_method.unable_to_find'), {}, {})
      else
        action = -> (prepaid_card) do
          purchase_amount = amount_in_cents / 100.0.to_d
          (authorize_code = prepaid_card.authorize(purchase_amount, order_number: get_order_number(gateway_options))) && prepaid_card.capture(purchase_amount, authorize_code, order_number: get_order_number(gateway_options))
        end
        handle_action_call(prepaid_card, action, :authorize)
      end
    end

    def credit(amount_in_cents, auth_code, gateway_options = {})
      action = -> (prepaid_card) do
        prepaid_card.credit(amount_in_cents / 100.0.to_d, auth_code, order_number: get_order_number(gateway_options))
      end

      handle_action(action, :credit, auth_code)
    end

    def source_required?
      true
    end

    private

    def handle_action_call(prepaid_card, action, action_name, auth_code = nil)
      prepaid_card.with_lock do
        if response = action.call(prepaid_card)
          ActiveMerchant::Billing::Response.new(
            true,
            Spree.t('prepaid_card_payment_method.successful_action', action: action_name),
            {},
            authorization: auth_code || response
          )
        else
          ActiveMerchant::Billing::Response.new(false, prepaid_card.errors.full_messages.join, {}, {})
        end
      end
    end

    def handle_action(action, action_name, auth_code)
      prepaid_card = CardTransaction.find_by(authorization_code: auth_code).try(:prepaid_card)

      if prepaid_card.nil?
        ActiveMerchant::Billing::Response.new(
          false,
          Spree.t('prepaid_card_payment_method.unable_to_find_for_action', auth_code: auth_code, action: action_name),
          {},
          {}
        )
      else
        handle_action_call(prepaid_card, action, action_name, auth_code)
      end
    end

    def get_order_number(gateway_options)
      gateway_options[:order_id].split('-').first if gateway_options[:order_id]
    end
  end
end
