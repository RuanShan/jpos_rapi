
class ApplicationController < ActionController::Base
  include Application::CommonHelper
  rescue_from CanCan::AccessDenied, with: :unauthorized
  rescue_from ActionController::ParameterMissing, with: :error_during_processing
  rescue_from ActiveRecord::RecordInvalid, with: :error_during_processing
  rescue_from ActiveRecord::RecordNotFound, with: :forbidden

  # add method spree requried
  #include Spree::Core::ControllerHelpers::Auth
  #include Spree::Core::ControllerHelpers::Common
  #include Spree::Core::ControllerHelpers::Order
  #include Spree::Core::ControllerHelpers::Store
  #helper 'spree/base'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :reset_session # TODO: is this what I want?

  before_action :set_client_store
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cache_header

  add_flash_types :error, :success # available flash types: notice, alert, error, success


  def check_access_level(role)
    redirect_to root_path unless current_user && current_user.role?(role)
  end

  #rescue_from CanCan::AccessDenied do |exception|
  #  redirect_to main_app.root_url, alert: exception.message
  #end

  # concerns
  include Application::DeviseSetup
  include Application::Present # presenter helper method

  def get_openid
    openid = ( params[:openid] || cookies.signed_or_encrypted[:we_openid]  )
  end

  def set_client_store
    Spree::Store.current= Spree::Store.where( id: request.headers['X-Jpos-Site-Id'] ).first
  end


  def forbidden
    render 'errors/forbidden', status: 403
  end

  def unauthorized
    render 'errors/unauthorized', status: 401
  end

  def no_entry_today
    render 'errors/no_entry_today', status: 401
  end

  def error_during_processing(exception)
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.join("\n")

    unprocessable_entity(exception.message)
  end

  def unprocessable_entity(message)
    render plain: { exception: message }.to_json, status: 422
  end

  def set_cache_header
    #https://stackoverflow.com/questions/711418/how-to-prevent-browser-page-caching-in-rails
    #https://www.jianshu.com/p/e59d16a9ab7e
    #禁止浏览器使用缓存
    if devise_controller? || request.fullpath=~/\/(api|user)/
      headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
      headers['Pragma'] = 'no-cache'
      headers['Expires'] = '0'
    end
  end
end
