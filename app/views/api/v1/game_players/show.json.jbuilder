json.game_player do
  json.partial! "api/v1/game_players/game_player", game_player: @game_player
end
