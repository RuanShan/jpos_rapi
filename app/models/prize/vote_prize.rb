#积攒奖励
#需求案例：当玩家获得N个赞，奖励什么商品
class Prize::VotePrize < GameAward

  def offer_to( game_player)
    game_award_player = game_player.game_award_players.build( game_player: game_player, game_round: self.game_round, scores: game_player.votes_count  )
    game_award_player.game_award_id= self.id
    game_award_player.save!
    self.prize_count -= 1
    self.save!
  end
end
