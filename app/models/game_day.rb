class GameDay < ApplicationRecord
  belongs_to :game_player
  has_many :game_results


  def is_paid?
    false
  end
end
