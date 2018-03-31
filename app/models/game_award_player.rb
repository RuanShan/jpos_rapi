class GameAwardPlayer < ApplicationRecord
  belongs_to :game_round , required: true
  belongs_to :game_player, required: true
  belongs_to :game_award, required: true

  delegate :nickname, :avatar, to: :game_player
end
