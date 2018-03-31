json.game_award_player do
  json.partial! "api/v1/game_award_players/game_award_player", game_award_player: @game_award_player
end
