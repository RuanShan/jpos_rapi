module Spree
  module AuthenticationHelpers
    def self.included(receiver)
      receiver.send :helper_method, :spree_current_user
      receiver.send :helper_method, :spree_login_path
      receiver.send :helper_method, :spree_signup_path
      receiver.send :helper_method, :spree_logout_path
    end

    def spree_current_user
      current_user
    end

    def spree_login_path
      new_user_session_path
    end

    def spree_signup_path
      new_user_registration_path
    end

    def spree_logout_path
      destroy_user_session_path
    end
  end
end
