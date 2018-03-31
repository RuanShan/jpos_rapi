require 'rails_helper'

describe DashboardController do
  login_user

  let(:dashboard_controller) { subject }

  it 'has a current_user' do
    expect(dashboard_controller.current_user).to_not be_nil
  end

  describe "GET 'index'" do
    before do
      get 'index'
    end

    it 'returns http success' do
      expect(response).to be_success
    end

    it 'set @lists_of_gems' do
      expect(assigns(:lists_of_gems)).to be_kind_of(ListOfGems)
    end
  end

end
