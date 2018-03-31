json.extract! game_day, :id, :game_player_id, :day, :play_count, :share_count, :created_at, :updated_at
json.url game_day_url(game_day, format: :json)