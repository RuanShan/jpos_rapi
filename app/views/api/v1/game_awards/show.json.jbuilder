json.game_award do
  json.partial! "api/v1/game_awards/game_award", game_award: @game_award
end
