class Prize::CashPrize < GameAward

  #
  #用户只能领一次红包
  def offer_to( game_player)
    #每天前二次才有机会
    #如果分享了，多一次机会
    unless GameAwardPlayer.exists?( game_award: self, game_round: self.game_round, game_player: game_player )
      game_today = game_player.game_today
      if game_today
        #每天最多可以得红包的次数 = 每日前几次有机会得红包 + 分享后多得的机会
        total_count = self.day_play_count_limit + self.day_share_plus
        if game_today.exercise_count < total_count
          if  game_today.play_count <= self.day_play_count_limit #每日玩的次数
            game_today.exercise_count+=1
          elsif game_today.share_count >0 #每日分享次数
            game_today.exercise_count+=1
          end

          if game_today.exercise_count_changed?
            if game_player.score >= self.score
              game_award_player = game_award_players.build( game_player: game_player, game_round: self.game_round, scores: game_player.score  )
              game_award_player.save!
            end
            game_today.save!
          end

        end
      end
    end
  end
end
