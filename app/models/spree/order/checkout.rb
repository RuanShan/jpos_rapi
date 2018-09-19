module Spree
  class Order < Spree::Base
    module Checkout
      def self.included(klass)

        klass.class_eval do
          state_machine :state, initial: :cart, use_transactions: false, action: :save_state do

            # Persist the state on the order
            after_transition do |order, transition|
              order.state_changes.create(
                previous_state: transition.from,
                next_state: transition.to,
                name: 'order',
                user_id: order.user_id
              )
              order.save
            end

            event :cancel do
              transition to: :canceled, if: :allow_cancel?
            end

            event :return do
              transition to: :returned,
                         from: [:complete, :awaiting_return, :canceled, :returned, :resumed]
            end

            event :resume do
              transition to: :resumed, from: :canceled, if: :canceled?
            end

            event :authorize_return do
              transition to: :awaiting_return
            end


            after_transition to: :complete, do: :finalize!
            after_transition to: :resumed, do: :after_resume
            after_transition to: :canceled, do: :after_cancel

            #after_transition from: any - :cart, to: any - [:complete] do |order|
            #  order.update_totals
            #  order.persist_totals
            #end
          end

        end

      end
    end
  end
end
