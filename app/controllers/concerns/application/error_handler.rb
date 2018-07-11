module Application::ErrorHandler
  rescue_from CanCan::AccessDenied, with: :unauthorized
  rescue_from ActionController::ParameterMissing, with: :error_during_processing
  rescue_from ActiveRecord::RecordInvalid, with: :error_during_processing
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
end
