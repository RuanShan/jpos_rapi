class LocalDevise::SessionsController < Devise::SessionsController
  respond_to :html, :json
  skip_before_action :verify_authenticity_token, if: :is_cors?


  def is_cors?
Rails.logger.debug "local=#{request.local?} xhr=#{ request.xhr?} "
    request.local? 
  end
end
