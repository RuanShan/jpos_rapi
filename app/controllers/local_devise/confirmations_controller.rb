class LocalDevise::ConfirmationsController < Devise::ConfirmationsController

  # GET /resource/confirmation?confirmation_token=abcdef
  # rubocop:disable Metrics/AbcSize
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      if resource.user_exists_but_force_password_reset?
        # TODO: is security issue created by connecting password creation to email confirmation?
        set_flash_message(:notice, :confirmed_need_password) if is_navigational_format?
        token = set_reset_password_token(resource)
        respond_with_navigational(resource) { redirect_to after_confirmation_set_password_path_for(token) }
      else
        resource.confirmation_token = nil # since update_attribute picks this up as a 'dirty' attribute
        # resource.update_attribute(:role, 'user') if resource.role?('guest') # force manual update by admin
        set_flash_message(:notice, :confirmed) if is_navigational_format?
        respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
      end
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
    end
  end
  # rubocop:enable all

  private

  # TODO: :reek:FeatureEnvy :reek:UtilityFunction
  def set_reset_password_token(resource)
    raw, enc = Devise.token_generator.generate(resource.class, :reset_password_token)
    resource.reset_password_token   = enc
    resource.reset_password_sent_at = Time.now.utc
    resource.save!(validate: false)
    raw
  end

  def after_confirmation_path_for(resource_name, resource)
    new_session_path(resource_name)
  end

  def after_confirmation_set_password_path_for(token)
    edit_user_password_path(reset_password_token: token)
  end

end
