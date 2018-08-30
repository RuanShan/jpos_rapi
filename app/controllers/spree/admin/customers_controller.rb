module Spree
  module Admin
    class CustomersController < ResourceController
      rescue_from Spree::Core::DestroyWithOrdersError, with: :customer_destroy_with_orders_error

      after_action :sign_in_if_change_own_password, only: :update

      def show
        redirect_to edit_admin_customer_path(@customer)
      end

      def create
        @customer = Spree.customer_class.new(customer_params)
        if @customer.save
          flash[:success] = flash_message_for(@customer, :successfully_created)
          redirect_to edit_admin_customer_path(@customer)
        else
          render :new
        end
      end

      def update
        if params[:customer][:password].blank? && params[:customer][:password_confirmation].blank?
          params[:customer].delete(:password)
          params[:customer].delete(:password_confirmation)
        end

        if @customer.update_attributes(customer_params)
          flash[:success] = Spree.t(:account_updated)
          redirect_to edit_admin_customer_path(@customer)
        else
          render :edit
        end
      end

      def addresses
        if request.put?
          if @customer.update_attributes(customer_params)
            flash.now[:success] = Spree.t(:account_updated)
          end

          render :addresses
        end
      end

      def orders
        params[:q] ||= {}
        @search = Spree::Order.reverse_chronological.ransack(params[:q].merge(user_id_eq: @customer.id))
        @orders = @search.result.page(params[:page])
      end

      def items
        params[:q] ||= {}
        @search = Spree::Order.includes(
          line_items: {
            variant: [:product, { option_values: :option_type }]
          }).ransack(params[:q].merge(user_id_eq: @customer.id))
        @orders = @search.result.page(params[:page])
      end

      def cards
        params[:q] ||= {}
        @search = Spree::Card.ransack(params[:q].merge(user_id_eq: @customer.id))
        @cards = @search.result.page(params[:page])
      end

      def generate_api_key
        if @customer.generate_spree_api_key!
          flash[:success] = Spree.t('api.key_generated')
        end
        redirect_to edit_admin_customer_path(@customer)
      end

      def clear_api_key
        if @customer.clear_spree_api_key!
          flash[:success] = Spree.t('api.key_cleared')
        end
        redirect_to edit_admin_customer_path(@customer)
      end

      def model_class
        Customer
      end

      protected

      def collection
        return @collection if @collection.present?
        @collection = super
        @search = @collection.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_customers_per_page])
      end

      private

      def customer_params
        params.require(:customer).permit(permitted_customer_attributes |
                                     [:use_billing,
                                      spree_role_ids: [],
                                      ship_address_attributes: permitted_address_attributes,
                                      bill_address_attributes: permitted_address_attributes])
      end

      # handling raise from Spree::Admin::ResourceController#destroy
      def customer_destroy_with_orders_error
        invoke_callbacks(:destroy, :fails)
        render status: :forbidden, plain: Spree.t(:error_customer_destroy_with_orders)
      end

      def sign_in_if_change_own_password
        if try_spree_current_customer == @customer && @customer.password.present?
          sign_in(@customer, event: :authentication, bypass: true)
        end
      end
    end
  end
end
