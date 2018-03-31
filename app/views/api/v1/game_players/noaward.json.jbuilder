json.game_players do
  json.array! @game_players do |game_player|
    json.(game_player, :id, :game_round_id, :avatar, :nickname, :position)
  end
end
