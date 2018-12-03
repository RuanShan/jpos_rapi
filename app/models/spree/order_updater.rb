module Spree
  class OrderUpdater
    attr_reader :order
    delegate :payments, :line_items, :line_item_groups, :adjustments, :all_adjustments, :shipments, :update_hooks, :quantity, to: :order

    def initialize(order)
      @order = order
    end

    # This is a multi-purpose method for processing logic related to changes in the Order.
    # It is meant to be called from various observers so that the Order is aware of changes
    # that affect totals and other values stored in the Order.
    #
    # This method should never do anything to the Order that results in a save call on the
    # object with callbacks (otherwise you will end up in an infinite recursion as the
    # associations try to save and then in turn try to call +update!+ again.)
    def update
      update_item_count
      update_group_state
      update_totals
      if order.completed?
        update_payment_state
      end
      update_order_type
      update_odd_card_paid
      update_sale_total

      #run_hooks
      persist_totals
    end

    def run_hooks
      update_hooks.each { |hook| order.send hook }
    end


    # Updates the following Order total values:
    #
    # +payment_total+      The total value of all finalized Payments (NOTE: non-finalized Payments are excluded)
    # +item_total+         The total value of all LineItems
    # +adjustment_total+   The total value of all adjustments (promotions, credits, etc.)
    # +promo_total+        The total value of all promotion adjustments
    # +total+              The so-called "order total."  This is equivalent to +item_total+ plus +shipment_total+ plus +adjustment_total+.
    def update_totals
      update_payment_total
      update_item_total
      update_order_total
    end


    def update_payment_total
      order.payment_total = payments.completed.includes(:refunds).inject(0) { |sum, payment| sum + payment.amount - payment.refunds.sum(:amount) }
    end



    def update_order_total
      order.total = order.item_total + order.shipment_total + order.adjustment_total
    end


    def update_item_count
      order.item_count = quantity
    end

    def update_item_total
      order.item_total = line_items.sum('price * quantity')
      update_order_total
    end

    def persist_totals
      order.update_columns(
        group_state: order.group_state,
        payment_state: order.payment_state,
        item_total: order.item_total,
        item_count: order.item_count,
        payment_total: order.payment_total,
        total: order.total,
        odd_card_paid: order.odd_card_paid,
        updated_at: Time.current
      )
    end

    def update_group_state
        order.group_count = line_item_groups.count
        uncanceled_group_states = line_item_groups.uncanceled.states

        group_states =  line_item_groups.states.uniq
        #only all line_item_groups has same state, then update order.group_state
        if group_states.size == 1
          order.group_state =  group_states.first
        elsif uncanceled_group_states.size == 1
          order.group_state =  uncanceled_group_states.first
        end

        #if order.canceled_at.present?
        #  order.group_state = 'canceled'
        #end

        #如果 order.group_state  是 canceled, 或者 shipped， 我们认为订单已经完结
        #设置订单完结时间 order.completed_at
        if ['canceled', 'shipped'].include? order.group_state
           order.completed_at = DateTime.current
        end

    end

    #检查是否为 客户办卡订单，会员卡充值订单
    def update_order_type
      if line_items.count  == 1
        if line_items.first.product.is_a? Selling::PrepaidCard
          order.order_type = Spree::Order.order_types[:card]
        end
      end
    end

    def update_odd_card_paid
      payments.each{| payment |
        Rails.logger.debug payment.source.inspect
        if payment.source.is_a? Spree::Card
          Rails.logger.debug( ( payment.source.store_id != order.store_id ) )
          order.odd_card_paid = ( payment.source.store_id != order.store_id )
        end
      }
    end

    # Updates the +payment_state+ attribute according to the following logic:
    #
    # paid          when +payment_total+ is equal to +total+
    # balance_due   when +payment_total+ is less than +total+
    # credit_owed   when +payment_total+ is greater than +total+
    # failed        when most recent payment is in the failed state
    # void          when order is canceled and +payment_total+ is equal to zero
    #
    # The +payment_state+ value helps with reporting, etc. since it provides a quick and easy way to locate Orders needing attention.
    def update_payment_state
      last_state = order.payment_state
      if payments.present? && payments.valid.empty?
        order.payment_state = 'failed'
      elsif order.canceled? && order.payment_total == 0
        order.payment_state = 'void'
      else
        order.payment_state = 'balance_due' if order.outstanding_balance > 0
        order.payment_state = 'credit_owed' if order.outstanding_balance < 0
        order.payment_state = 'paid' unless order.outstanding_balance?
        order.payment_state = 'unpaid' if order.payments.blank?
      end
      order.state_changed('payment') if last_state != order.payment_state
      order.payment_state
    end

    def update_sale_total
      order.sale_total = line_items.sum(&:sale_price)
    end
  end
end
