require 'rails_helper'

RSpec.describe Campaign, type: :model do

  describe '#genre' do
    before :each do
      create :game, code: Game.codes["runlin_car_game"]
    end
    it "create  runlin car game" do
      expect do
        campaign = Campaign.create( genre: :runlin_car_game, name: 'sample')
      end.to change(Campaign, :count)
    end

    it "create  runlin car game and game ground" do
      expect do
        campaign = Campaign.create( genre: :runlin_car_game, name: 'sample')
      end.to change(GameRound, :count)
    end

  end
end
