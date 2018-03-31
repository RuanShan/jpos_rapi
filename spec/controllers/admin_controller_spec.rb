require 'rails_helper'

describe AdminController do
  login_user

  let(:admin_controller) { subject }

  describe "GET 'index'" do
    it 'returns http success as admin' do
      admin_controller.current_user.role = 'admin'
      get 'index'
      expect(response).to be_success
    end

    it 'redirect user to home' do
      admin_controller.current_user.role = 'user'
      get 'index'
      expect(response).to redirect_to '/'
    end
  end

end
