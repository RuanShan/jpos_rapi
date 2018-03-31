json.paginate_meta do
  paginate_meta_attributes(json, @game_players)
end
json.game_players do
  json.array! @game_players, partial: 'api/v1/game_players/game_player', as: :game_player
end
