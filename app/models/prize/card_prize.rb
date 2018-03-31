#卡券奖励
#需求案例：当玩家连续七天登录游戏，奖励卡券
class Prize::CardPrize < GameAward

  #当玩家连续n天登录游戏，奖励卡券
  #用户只能领一次
  def offer_to( game_player)
    unless GameAwardPlayer.exists?( game_award: self, game_round: self.game_round, game_player: game_player )
      if self.game_cdays_required > 0
        continue_play_day_count = game_player.game_days.where( ['day >?', (DateTime.current - self.game_cdays_required.days).to_date]).count
        Rails.logger.debug " continue_play_day_count = #{continue_play_day_count}"
        if continue_play_day_count >= self.game_cdays_required
          game_award_player = game_award_players.build( game_player: game_player, game_round: self.game_round, scores: game_player.score  )
          game_award_player.save!
        end
      end
    end
  end
end
