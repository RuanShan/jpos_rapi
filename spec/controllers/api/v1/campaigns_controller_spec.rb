require 'rails_helper'

RSpec.describe Api::V1::CampaignsController, type: :controller do

  #before :each do
  #  @tester = create(:user, :username => "jdoe", :password => "secret")
  #end


  it "create campaign" do
    api_post :create, name: 'test'
  end
end
