module Spree
  module Admin
    class  CardTransactionsController < Spree::Admin::BaseController
      before_action :initialize_order_events
      before_action :load_order, only: [:edit, :update, :cancel, :resume, :approve, :resend, :open_adjustments, :close_adjustments, :cart, :store, :set_store]

      respond_to :html

      def index
        params[:q] ||= {}


        # As date params are deleted if @show_only_completed, store
        # the original date so we can restore them into the params
        # after the search
        created_at_gt = params[:q][:created_at_gt]
        created_at_lt = params[:q][:created_at_lt]


        if params[:q][:created_at_gt].present?
          params[:q][:created_at_gt] = begin
                                         Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day
                                       rescue
                                         ''
                                       end
        end

        if params[:q][:created_at_lt].present?
          params[:q][:created_at_lt] = begin
                                         Time.zone.parse(params[:q][:created_at_lt]).end_of_day
                                       rescue
                                         ''
                                       end
        end


        @search = Spree::CardTransaction.preload(:card, :order).accessible_by(current_ability, :index).deposit.ransack(params[:q])

        # lazy loading other models here (via includes) may result in an invalid query
        # e.g. SELECT  DISTINCT DISTINCT "spree_orders".id, "spree_orders"."created_at" AS alias_0 FROM "spree_orders"
        # see https://github.com/spree/spree/pull/3919
        @orders = @search.result(distinct: true).
                  page(params[:page]).
                  per(params[:per_page] || Spree::Config[:admin_orders_per_page])

        # Restore dates
        params[:q][:created_at_gt] = created_at_gt
        params[:q][:created_at_lt] = created_at_lt
      end

      def new
        @order = Spree::Order.create(order_params)
        redirect_to cart_admin_order_url(@order)
      end

      def edit
        can_not_transition_without_customer_info

        @order.refresh_shipment_rates(ShippingMethod::DISPLAY_ON_BACK_END) unless @order.completed?
      end

      def cart
        @order.refresh_shipment_rates(ShippingMethod::DISPLAY_ON_BACK_END) unless @order.completed?

        if @order.shipments.shipped.exists?
          redirect_to edit_admin_order_url(@order)
        end
      end

      def store
        @stores = Spree::Store.all
      end

      def update
        if @order.update_attributes(params[:order]) && @order.line_items.present?
          @order.update_with_updater!
          unless @order.completed?
            # Jump to next step if order is not completed.
            redirect_to admin_order_customer_path(@order) and return
          end
        else
          @order.errors.add(:line_items, Spree.t('errors.messages.blank')) if @order.line_items.empty?
        end

        render action: :edit
      end

      def cancel
        @order.canceled_by(try_spree_current_user)
        flash[:success] = Spree.t(:order_canceled)
        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def resume
        @order.resume!
        flash[:success] = Spree.t(:order_resumed)
        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def approve
        @order.approved_by(try_spree_current_user)
        flash[:success] = Spree.t(:order_approved)
        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def resend
        OrderMailer.confirm_email(@order.id, true).deliver_later
        flash[:success] = Spree.t(:order_email_resent)

        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def open_adjustments
        adjustments = @order.all_adjustments.closed
        adjustments.update_all(state: 'open')
        flash[:success] = Spree.t(:all_adjustments_opened)

        respond_with(@order) { |format| format.html { redirect_back fallback_location: spree.admin_order_adjustments_url(@order) } }
      end

      def close_adjustments
        adjustments = @order.all_adjustments.open
        adjustments.update_all(state: 'closed')
        flash[:success] = Spree.t(:all_adjustments_closed)

        respond_with(@order) { |format| format.html { redirect_back fallback_location: spree.admin_order_adjustments_url(@order) } }
      end

      def set_store
        if @order.update_attributes(store_id: params[:order][:store_id])
          flash[:success] = flash_message_for(@order, :successfully_updated)
        else
          flash[:error] = @order.errors.full_messages.join(', ')
        end

        redirect_to store_admin_order_url(@order)
      end

      private

      def order_params
        params[:created_by_id] = try_spree_current_user.try(:id)
        params.permit(:created_by_id, :user_id, :store_id)
      end

      def load_order
        @order = Spree::Order.includes(:adjustments).find_by!(number: params[:id])
        authorize! action, @order
      end

      # Used for extensions which need to provide their own custom event links on the order details view.
      def initialize_order_events
        @order_events = %w{approve cancel resume}
      end

      def model_class
        Spree::Order
      end
    end
  end
end
