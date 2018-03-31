class Prize::FirstAchievedPrize < GameAward
  after_initialize :fix_now_date, if: :persisted?

  def available_to?( game_player )
    available = false
    #判断该用户分数是否>=100分？如果是，则系统判断该用户是否当天第一次达到？如果是，则弹出摇奖页，如左图。（一天只抽一次奖）
    grs = game_player.game_today.game_results
    game_result = grs.last
    if game_result.score >= self.score

      if self.day_first_achieved_required #当天第一次达到
        if game_player.game_today.game_results.where( ['created_at<? and score>=?', game_result.created_at, self.score ]).empty?
          available = true
        end
      else
        available = true
      end
    end
    #当天奖品被抽完后，就不会再有用户中奖。
    if self.now_prize_count == 0
      available = false
    end
    #如果有玩家中奖后，今后再抽奖都不能中奖（保证每人只中一个奖品）
    game_player.game_award_players.each{|game_award_player|
      if game_award_player.game_award_id == self.id
        available = false
        break
      end
    }
    available
  end

  def offer_to( game_player)
    game_award_player = nil

    game_player.game_today.lot_count+=1

    if yiy
      game_award_player = game_award_players.build( game_player: game_player, game_round: self.game_round, scores: game_player.score  )
      game_award_player.save!
      game_player.game_today.award_count+=1
    end
    game_player.game_today.save

    game_award_player
  end


  def yiy( )
    rand(100) < day_probability
  end

  # now_date, now_prize_count 保存当天的 日期和奖品数量
  def fix_now_date
    if self.now_date.nil?
      if game_round.start_at.present? && game_round.start_at.today?
        self.now_date = game_round.start_at.to_date
        self.now_prize_count = self.day_prize_count
        self.save
      end
    end

    if self.now_date == DateTime.current.to_date.yesterday
      self.now_date =  DateTime.current.to_date
      self.now_prize_count = self.now_prize_count + self.day_prize_count
      self.save
    end
  end
end
