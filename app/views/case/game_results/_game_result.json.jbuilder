json.extract! game_result, :id, :score, :game_player_id, :trail, :created_at, :updated_at
json.url game_result_url(game_result, format: :json)