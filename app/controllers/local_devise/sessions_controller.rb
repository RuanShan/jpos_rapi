class LocalDevise::SessionsController < Devise::SessionsController



  def after_sign_in_path_for( resource_or_scope )
    case_root_path
  end
end
