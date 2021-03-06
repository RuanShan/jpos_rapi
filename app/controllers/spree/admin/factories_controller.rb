module Spree
  module Admin
    class FactoryController < StoresController
      before_action :load_store, only: [:new, :edit, :update]

      def index
        @stores = Spree::Factory.all
      end

      def create
        @store = Spree::Factory.new(permitted_store_params)

        if @store.save
          flash[:success] = flash_message_for(@store, :successfully_created)
          redirect_to admin_stores_path
        else
          flash[:error] = "#{Spree.t('store.errors.unable_to_create')}: #{@store.errors.full_messages.join(', ')}"
          render :new
        end
      end

      def update
        @store.assign_attributes(permitted_store_params)

        if @store.save
          flash[:success] = flash_message_for(@store, :successfully_updated)
          redirect_to admin_stores_path
        else
          flash[:error] = "#{Spree.t('store.errors.unable_to_update')}: #{@store.errors.full_messages.join(', ')}"
          render :edit
        end
      end

      def destroy
        @store = Spree::Factory.find(params[:id])

        if @store.destroy
          flash[:success] = flash_message_for(@store, :successfully_removed)
          respond_with(@store) do |format|
            format.html { redirect_to admin_stores_path }
            format.js { render_js_for_destroy }
          end
        else
          render plain: "#{Spree.t('store.errors.unable_to_delete')}: #{@store.errors.full_messages.join(', ')}", status: :unprocessable_entity
        end
      end

      def set_default
        store = Spree::Factory.find(params[:id])
        stores = Spree::Factory.where.not(id: params[:id])

        ApplicationRecord.transaction do
          store.update(default: true)
          stores.update_all(default: false)
        end

        if store.errors.empty?
          flash[:success] = Spree.t(:store_set_as_default, store: store.name)
        else
          flash[:error] = "#{Spree.t(:store_not_set_as_default, store: store.name)} #{store.errors.full_messages.join(', ')}"
        end

        redirect_to admin_stores_path
      end

      protected

      def permitted_store_params
        params.require(:store).permit(permitted_store_attributes)
      end

      private

      def load_store
        @store = Spree::Factory.find_by(id: params[:id]) || Spree::Factory.new
      end
    end
  end
end
