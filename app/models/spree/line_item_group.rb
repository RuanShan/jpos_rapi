# 记录商品的处理流程
# pending : 店里收到商品
# ready_for_factory: 准备发货到工厂
# processing: 工厂处理
# ready_for_store: 准备发货到店里
# ready: 可以交给客户了
# shipped: 已交付客户

require 'ostruct'

module Spree
  class LineItemGroup < Spree::Base

    with_options inverse_of: :line_item_groups do
      belongs_to :store, class_name: 'Spree::Store'
      belongs_to :order, class_name: 'Spree::Order', touch: true
    end

    with_options dependent: :delete_all do
      has_many :state_changes, as: :stateful
    end


    before_validation :set_price_zero_when_nil

    validates :number, uniqueness: true

    attr_accessor :special_instructions


    scope :pending, -> { with_state('pending') }
    scope :ready,   -> { with_state('ready') }
    scope :shipped, -> { with_state('shipped') }
    scope :with_state, ->(*s) { where(state: s) }
    # sort by most recent shipped_at, falling back to created_at. add "id desc" to make specs that involve this scope more deterministic.
    scope :reverse_chronological, -> { order(Arel.sql('coalesce(spree_line_item_groups.shipped_at, spree_line_item_groups.created_at) desc'), id: :desc) }

    # shipment state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
    state_machine initial: :pending, use_transactions: false do
      event :ready do
        transition from: :pending, to: :ready, if: lambda { |shipment|
          # Fix for #2040
        }
      end

      event :pend do
        transition from: :ready, to: :pending
      end

      event :ship do
        transition from: %i(ready canceled), to: :shipped
      end
      after_transition to: :shipped, do: :after_ship

      event :cancel do
        transition to: :canceled, from: %i(pending ready)
      end
      after_transition to: :canceled, do: :after_cancel

      event :resume do
        transition from: :canceled, to: :ready, if: lambda { |shipment|
        }
        transition from: :canceled, to: :pending
      end
      after_transition from: :canceled, to: %i(pending ready shipped), do: :after_resume

      after_transition do |line_item_group, transition|
        line_item_group.state_changes.create!(
          previous_state: transition.from,
          next_state:     transition.to,
          name:           'line_item_group'
        )
      end

      #########################################################################
      # For POS
      #########################################################################
      #准备发到工厂
      event :prepare_for_factory do
        transition to: :ready_for_factory, from: %i(pending ready)
      end
      #进入工厂
      event :admit do
        transition to: :processing, from: %i(ready_for_factory)
      end
      #准备发到店铺
      event :prepare_for_store do
        transition to: :ready_for_store, from: %i(processing)
      end
      #店铺接收
      event :approve do
        transition to: :ready, from: %i(ready_for_store)
      end

      #工厂确认工作量
      event :fulfill do
        transition to: :processed, from: %i(processed, processing)
      end

      event :next do
        # pending -> ready_for_factory -> processing -> processed -> ready_for_store -> ready -> shipped
        transition pending: :ready_for_factory,  ready_for_factory: :processing,
          processing: :processed, processed: :ready_for_store, ready_for_store: :ready, ready: :shipped
      end

      event :draw_back do
        #
        transition ready_for_factory: :pending, ready_for_store: :processed,
          processed: :processing,  processing: :ready_for_factory,
          shipped: :ready, ready: :pending
      end

      event :complete do
        transition all => :shipped
      end
    end

    self.whitelisted_ransackable_associations = %w[order]
    self.whitelisted_ransackable_attributes = %w[ number state order_id]

    extend DisplayMoney
    money_methods :cost, :discounted_cost, :final_price, :item_cost
    alias display_amount display_cost

    def make_step_and_order( forward= true )
      forward ? next! : draw_back!
      order.updater.update_group_state
      order.save!
    end

    def finalize!
      complete!
      order.updater.update_group_state
      order.save!
    end


    def currency
      order ? order.currency : Spree::Config[:currency]
    end

    # Determines the appropriate +state+ according to the following logic:
    #
    # pending    unless order is complete and +order.payment_state+ is +paid+
    # shipped    if already shipped (ie. does not change the state)
    # ready      all other cases
    def determine_state(order)

      return 'canceled' if order.canceled?
      return 'pending' unless order.can_ship?

      return 'shipped' if shipped?

    end

    def discounted_cost
      cost + promo_total
    end
    alias discounted_amount discounted_cost

    def final_price
      cost + adjustment_total
    end

    def final_price_with_items
      item_cost + final_price
    end


    def include?(variant)
      inventory_units_for(variant).present?
    end



    def line_items

      LineItem.where( group_number: number )

    end


    def shipped=(value)
      return unless value == '1' && shipped_at.nil?
      self.shipped_at = Time.current
    end




    # Updates various aspects of the Shipment while bypassing any callbacks.  Note that this method takes an explicit reference to the
    # Order object.  This is necessary because the association actually has a stale (and unsaved) copy of the Order and so it will not
    # yield the correct results.
    def update!(order)
      old_state = state
      new_state = determine_state(order)
      update_columns(
        state: new_state,
        updated_at: Time.current
      )
      after_ship if new_state == 'shipped' && old_state != 'shipped'
    end

    private

    def set_price_zero_when_nil
      self.price = 0 unless price
    end

    def after_ship

    end
  end
end
