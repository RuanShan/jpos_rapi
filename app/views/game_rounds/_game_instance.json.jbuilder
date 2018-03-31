json.extract! game_round, :id, :game, :name, :start_at, :end_at, :preferences, :created_at, :updated_at
json.url game_round_url(game_round, format: :json)