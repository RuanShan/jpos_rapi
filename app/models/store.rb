class Store < ApplicationRecord
  belongs_to :user
  has_many :game_players

  #剩余可报名人数
  def available_count
    self.player_limit - self.game_players.count
  end
end
