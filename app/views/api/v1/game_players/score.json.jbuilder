json.game_player do
  json.(@game_player, :id, :game_round_id, :nickname, :avatar, :realname,:cellphone, :score, :max_score, :current_position, :percent_position, :rank, :created_at)

  json.game_awards do
    json.array! @game_player.game_awards do |game_award|
      json.game_award do
        json.(game_award, :id, :name, :type, :prize_name, :position, :wx_card_id)
      end
    end
  end
end
