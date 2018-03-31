json.game_round do
  json.partial! "api/v1/game_rounds/game_round", game_round: @game_round
  json.game_awards do
    json.array! @game_round.game_awards, partial: 'api/v1/game_awards/game_award', as: :game_award
  end
end
