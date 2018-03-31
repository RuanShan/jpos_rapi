json.paginate_meta do
  paginate_meta_attributes(json, @game_rounds)
end
json.game_rounds do
  json.array! @game_rounds, partial: 'api/v1/game_rounds/game_round', as: :game_round
end
