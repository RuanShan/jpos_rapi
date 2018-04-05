class LocalDevise::SessionsController < Devise::SessionsController
  respond_to :html, :json
  skip_before_action :verify_authenticity_token, if: :is_cors?

  # POST /resource/sign_in
  def create

    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    bypass_sign_in( resource )
    yield resource if block_given?
    Rails.logger.debug "session=#{request.env['rack.session']} #{request.env['rack.session'].to_hash}"

    respond_with resource, location: after_sign_in_path_for(resource)
  end

  private
  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|

      format.html { redirect_to after_sign_out_path_for(resource_name) }
      format.json
    end
  end

  def is_cors?
Rails.logger.debug "local=#{request.local?} xhr=#{ request.xhr?} "
    request.local?
  end



end
