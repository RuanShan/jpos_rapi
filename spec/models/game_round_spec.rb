require 'rails_helper'

RSpec.describe GameRound, type: :model do

  describe 'aasm' do
    it "count down" do
      game_round = create(:game_round, aasm_state: 'ready')
      game_round.count_down
      expect(game_round.starting?).to be_truthy
    end

    it "open" do
      game_round = create(:game_round)
      game_round.open_at = DateTime.current
      expect(game_round.open?).to be_truthy
    end

    it "restart" do
      game_round = create(:game_round, cache_free_at: DateTime.current,  aasm_state: 'completed')
      game_round.restart

      expect(game_round.cache_free_at).to be_nil

    end

  end
end
