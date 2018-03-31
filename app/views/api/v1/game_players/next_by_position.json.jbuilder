json.by_position @position
json.game_player do
  if @game_player.present?
    json.(@game_player, :id, :avatar, :nickname, :position)
  end
end
