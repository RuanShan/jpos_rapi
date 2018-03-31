json.extract! vote, :id, :game_player_id, :openid, :voted_at, :created_at, :updated_at
json.url vote_url(vote, format: :json)
