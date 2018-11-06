module Application::AuditorGeneral
    extend ActiveSupport::Concern

    included do
      before_action :log_origin
    end

    def log_origin
      AuditorGeneralService.origin = @current_api_user.present? ? @current_api_user : 0
    end

end
