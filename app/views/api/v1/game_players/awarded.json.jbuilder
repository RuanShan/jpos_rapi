json.game_players do
  json.array! @game_players do |game_player|
    json.(game_player, :id, :avatar, :nickname, :position)
    json.array! game_player.game_awards do |game_award|
      json.game_award do
        json.(game_award, :id, :name, :prize_name, :position)
      end
    end
  end
end
