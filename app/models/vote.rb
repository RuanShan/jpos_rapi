class Vote < ApplicationRecord
  belongs_to :game_player, counter_cache: true

  validates_presence_of :game_player

  before_create :set_voted_at
  after_create :award_vote_prize
  validate :check_game_round_end_time


  private

  def set_voted_at
    self.voted_at||=DateTime.current.to_date
  end

  def check_game_round_end_time
    if game_player.game_round.end_at.present?
      Rails.logger.debug "current:#{DateTime.current}, game_round.end:#{ game_player.game_round.end_at } "
      errors.add(:voted_at, '游戏已结束，无法投票') if DateTime.current > game_player.game_round.end_at
    end
  end

  #检查用户积攒数是否到达奖品要求的数量，给与奖励
  def award_vote_prize
    award_players = game_player.game_award_players
    prizes = Prize::VotePrize.all
    available_prize_index = prizes.index{|prize| game_player.votes_count >= prize.score   }
    #Rails.logger.debug "available_prize_index=#{available_prize_index}"
    if available_prize_index
      prizes.each{| prize|
        awarded = award_players.index{|player| player.game_award_id == prize.id }
        #Rails.logger.debug "prize=#{prize.name}, awarded=#{awarded}"
        #没有领过奖品，积攒数够，并且奖品还有剩余
        unless awarded
          if game_player.votes_count >= prize.score
            if prize.prize_count>0
              prize.offer_to game_player
            end
          end
        end
      }
    end

  end
end
