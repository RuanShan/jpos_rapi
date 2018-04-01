class LocalDevise::RegistrationsController < Devise::RegistrationsController

  def show
    send(:"authenticate_#{resource_name}!")
    self.resource = send(:"current_#{resource_name}")
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
