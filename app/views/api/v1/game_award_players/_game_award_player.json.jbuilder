json.extract! game_award_player, :id, :scores
json.extract! game_award_player.game_player, :nickname, :avatar
json.game_award do
  json.(game_award_player.game_award, :id, :name, :prize_name)
end
