
class ApplicationController < ActionController::Base
  include Application::CommonHelper
  rescue_from CanCan::AccessDenied, with: :unauthorized
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :reset_session # TODO: is this what I want?

  before_action :set_store
  before_action :configure_permitted_parameters, if: :devise_controller?


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

  def set_store
    Spree::Store.current= Spree::Store.where( id: request.headers['X-Jpos-Site-Id'] ).first
  end


  def is_cors?
Rails.logger.debug "local=#{request.local?} xhr=#{ request.xhr?} "
    request.local? || request.host=~/jpos/
  end

  def unauthorized
    render 'errors/unauthorized', status: 401 and return
  end

end
