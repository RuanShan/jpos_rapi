require 'rails_helper'

RSpec.describe Api::V1::GameRoundsController, type: :controller do

  it "create game round" do
    api_post :create, name: 'test'
  end
end
