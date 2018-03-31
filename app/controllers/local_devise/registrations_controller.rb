class LocalDevise::RegistrationsController < Devise::RegistrationsController


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
