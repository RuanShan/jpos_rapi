json.extract! game_award, :id, :game_round_id, :position, :name, :prize_count, :prize_name, :created_at, :updated_at
json.url game_award_url(game_award, format: :json)