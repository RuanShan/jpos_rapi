class LocalDevise::RegistrationsController < Devise::RegistrationsController

  def show
    #Rails.logger.debug " current_user1=#{current_user.inspect}"
    send(:"authenticate_#{resource_name}!")
    #Rails.logger.debug "session=#{request.env['rack.session']} #{request.env['rack.session'].to_hash}"
    self.resource = send(:"current_#{resource_name}")
    # self.resource 可能为空
    if self.resource
      resource.today_entries = resource.user_entries.today
    end

  end

  private

  def after_inactive_sign_up_path_for(resource)
    root_path
  end

  def after_sign_up_path_for(resource)
    stored_location_for(resource) || signed_in_root_path(resource)
  end

  def after_update_path_for(resource)
    root_url
  end

end
