json.game_awards do
  json.array! @game_awards, partial: 'api/v1/game_awards/game_award', as: :game_award

end
