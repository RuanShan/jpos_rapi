module Spree
  class PaymentMethod::PrepaidCard < PaymentMethod
    def payment_source_class
      ::Spree::Card
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

    def authorize(amount_in_cents, card, gateway_options = {})
      simulated_successful_billing_response
    end

    def capture(amount_in_cents, authorize_code, gateway_options = {})
      order_number = get_order_number(gateway_options)
      order = Spree::Order.find_by_number( order_number )
      payment = order.payments.where(payment_method: self).first
      card = payment.source # PrepaidCard or TimesCard
      payment_number = payment.number

      action = -> (card) do
        purchase_amount = amount_in_cents / 100.0.to_d
        # authorize_code is required for cancel order
        card.capture(purchase_amount, authorize_code, { order_number: order_number, payment_number: payment_number })
      end
      handle_action_call(card, action, :capture)
    end

    def void(auth_code, gateway_options = {})
      action = -> (card) do
        card.void(auth_code, order_number: get_order_number(gateway_options))
      end
      handle_action(action, :void, auth_code)
    end

    def purchase(*)
      simulated_successful_billing_response
    end

    def credit(*)
      simulated_successful_billing_response
    end

    #整个订单被取消时，每个支付方式被设置为 void
    def cancel(auth_code)
      Rails.logger.debug "card cancel #{auth_code}"
      action = lambda do |card|
        card.cancel(auth_code)
      end
      handle_action(action, :cancel, auth_code)
    end

    def source_required?
      true
    end

    private

    def handle_action_call(card, action, action_name, auth_code = nil)
      card.with_lock do
        if response = action.call(card)
          ActiveMerchant::Billing::Response.new(
            true,
            Spree.t('card_payment_method.successful_action', action: action_name),
            {},
            authorization: auth_code || response
          )
        else
          ActiveMerchant::Billing::Response.new(false, card.errors.full_messages.join, {}, {})
        end
      end
    end

    def handle_action(action, action_name, auth_code)
      card = CardTransaction.find_by( id: auth_code).try(:card)

      if card.nil?
        ActiveMerchant::Billing::Response.new(
          false,
          Spree.t('card_payment_method.unable_to_find_for_action', auth_code: auth_code, action: action_name),
          {},
          {}
        )
      else
        handle_action_call(card, action, action_name, auth_code)
      end
    end

    def get_order_number(gateway_options)
      gateway_options[:order_id].split('-').first if gateway_options[:order_id]
    end

    def simulated_successful_billing_response
      ActiveMerchant::Billing::Response.new(true, '', {}, {})
    end
  end
end
