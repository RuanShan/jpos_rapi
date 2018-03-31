json.(game_round, :id, :appid, :name, :contact_required, :display_players, :duration, :play_times, :award_times, :aasm_state, :start_at, :end_at, :created_at)
json.check_in_url check_in_game_round_url(game_round)
json.play_url play_game_round_url(game_round)
