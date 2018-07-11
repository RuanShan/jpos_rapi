json.vote do
  json.partial! "votes/vote", vote: @vote
  json.game_player do
    json.(@vote.game_player, :id, :game_round_id, :realname, :votes_count)
  end
end
