json.game_award_players do

  json.array! @game_award_players, partial: 'api/v1/game_award_players/game_award_player', as: :game_award_player
end
