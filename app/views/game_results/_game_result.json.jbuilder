json.extract! game_result, :id, :score, :game_player_id, :created_at, :display_delivery_vendor, :display_delivery_time_option
json.url game_result_url(game_result, format: :json)
