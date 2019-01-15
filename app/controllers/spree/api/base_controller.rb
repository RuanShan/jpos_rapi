require_dependency 'spree/api/controller_setup'

module Spree
  module Api
    class BaseController < ActionController::Base
      include Spree::Api::ControllerSetup
      include Spree::Core::ControllerHelpers::Store
      include Spree::Core::ControllerHelpers::StrongParameters

      attr_accessor :current_api_user

      before_action :set_content_type
      before_action :load_user
      before_action :authorize_for_order, if: proc { order_token.present? }
      before_action :authenticate_user
      before_action :load_user_roles
      after_action :set_user_last_request_at

      rescue_from ActionController::ParameterMissing, with: :error_during_processing
      rescue_from ActiveRecord::RecordInvalid, with: :error_during_processing
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from CanCan::AccessDenied, with: :unauthorized
      rescue_from Spree::Core::GatewayError, with: :gateway_error

      include Application::AuditorGeneral #add before_action

      helper Spree::Api::ApiHelpers

      # users should be able to set price when importing orders via api
      def permitted_line_item_attributes
        if @current_user_roles.include?('admin')
          super + [:price, :variant_id, :sku]
        else
          super
        end
      end

      def content_type
        case params[:format]
        when 'json'
          'application/json; charset=utf-8'
        when 'xml'
          'text/xml; charset=utf-8'
        end
      end

      private

      def set_content_type
        headers['Content-Type'] = content_type
        # 由于继承关系 BaseController < ActionController::Base，需要单独设置
        headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
        headers['Pragma'] = 'no-cache'
        headers['Expires'] = '0'
      end

      def load_user
        @current_api_user = current_user
        if @current_api_user.blank?
          #postman 测试需要
          @current_api_user = Spree.user_class.find_by(spree_api_key: api_key.to_s)
        end

        #设置当前user,store 以便审计信息使用
        if @current_api_user
          User.current = @current_api_user
          store_id = request.headers['X-Jpos-Site-Id']
          Spree::Store.current = Spree::Store.where( id: store_id).first
        end

      end

      def authenticate_user
        #检查用户session是否过期, jpos 每个API请求都需要检查
        if @current_api_user.blank?
          session_expired
          return
        end
        # make sure cookies and api_key both right. in case user open multi window, login with vary account
        # check current_api_user.api_key  is same with api_key,
        #if @current_api_user.try(:api_key) != api_key
          Rails.logger.debug "@current_api_user.try(:api_key)=#{@current_api_user.try(:api_key)}, api_key=#{api_key}"
        #  reset_session
        #  session_expired
        #end

      end

      def invalid_api_key
        render 'spree/api/errors/invalid_api_key', status: 401
      end

      def must_specify_api_key
        render 'spree/api/errors/must_specify_api_key', status: 401
      end

      def load_user_roles
        @current_user_roles = @current_api_user ? @current_api_user.spree_roles.pluck(:name) : []
      end

      def session_expired
        render 'spree/api/errors/session_expired', status: 401 and return
      end

      def unauthorized
        render 'spree/api/errors/unauthorized', status: 401 and return
      end

      def error_during_processing(exception)
        Rails.logger.error exception.message
        Rails.logger.error exception.backtrace.join("\n")

        unprocessable_entity(exception.message)
      end

      def unprocessable_entity(message)
        render plain: { exception: message }.to_json, status: 422
      end

      def gateway_error(exception)
        @order.errors.add(:base, exception.message)
        invalid_resource!(@order)
      end

      def requires_authentication?
        Spree::Api::Config[:requires_authentication]
      end

      def not_found
        render 'spree/api/errors/not_found', status: 404 and return
      end

      def current_ability
        Spree::Ability.new(current_api_user)
      end

      def invalid_resource!(resource)
        @resource = resource
        render 'spree/api/errors/invalid_resource', status: 422
      end

      def api_key
        request.headers['X-Jpos-User-Token'] || params[:token]
      end
      helper_method :api_key

      def order_token
        request.headers['X-Spree-Order-Token'] || params[:order_token]
      end

      def find_product(id)
        @product = product_scope.friendly.distinct(false).find(id.to_s)
      rescue ActiveRecord::RecordNotFound
        @product = product_scope.find_by(id: id)
        not_found unless @product
      end

      def product_scope
        if @current_user_roles.include?('admin')
          scope = Product.with_deleted.accessible_by(current_ability, :read).includes(*product_includes)

          scope = scope.not_deleted unless params[:show_deleted]
          scope = scope.not_discontinued unless params[:show_discontinued]
        else
          scope = Product.accessible_by(current_ability, :read).active.includes(*product_includes)
        end

        scope
      end

      def variants_associations
        [{ option_values: :option_type }, :default_price, :images]
      end

      def product_includes
        [:option_types, :taxons, product_properties: :property, variants: variants_associations, master: variants_associations]
      end

      def order_id
        params[:order_id] || params[:checkout_id] || params[:order_number]
      end

      def authorize_for_order
        @order = Spree::Order.find_by(number: order_id)
        authorize! :read, @order, order_token
      end

      def set_user_last_request_at
        #cookies['_jpos_api_timestamp'] =  DateTime.current.to_i
        #@current_api_user.update_attributes last_request_at: DateTime.current
      end
    end
  end
end
