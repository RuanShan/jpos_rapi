json.game_player do
  json.partial! "game_player", game_player: @game_player

  json.wedding_photo do
    if @game_player.wedding_photo
      json.(@game_player.wedding_photo, :id)
    end
  end
end
