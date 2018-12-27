class GameResult < ApplicationRecord

  extend Spree::DisplayDateTime
  date_time_methods :created_at, :updated_at


  enum status: { normal: 0, question: 3, fake: 4 }, _prefix: true

  #取件时间选项 今中，今晚，明早，明中
  enum delivery_time_option: { tonoon: 0, tonignt: 1, nenoon: 10, nenight: 11,  }, _prefix: true
  #短信发送时间 今天，昨天，前天
  enum delivery_sms_option: { today: 0, yesterday: 1, before: 2, other: 9 }, _prefix: true


  belongs_to :game_round
  belongs_to :game_player, inverse_of: :game_results
  belongs_to :game_day, counter_cache: true
  serialize :trail, JSON

  validates_presence_of :game_player

  before_validation :set_defaults
  before_create :evaluate_trail_score
  after_create :update_game_player_score


  def display_delivery_time_option
    self.class.translate_enum_name(:delivery_time_option, delivery_time_option)
  end

  # return -1 0 1
  def compare( other_game_result)

    if self.score == other_game_result.score
      if self.time_span == other_game_result.time_span
        if self.created_at < other_game_result.created_at
          1
        elsif self.created_at == other_game_result.created_at
          0
        else
          -1
        end
      elsif self.time_span < other_game_result.time_span
        1
      else
        -1
      end
    elsif self.score > other_game_result.score
      1
    else
      -1
    end
  end

  private
  def set_defaults
    self.end_at ||= DateTime.current
    self.game_day ||= self.game_player.game_today
    self.game_round ||= self.game_player.game_round
    self.time_span = self.end_at.to_i - self.start_at.to_i
  end

  #更新玩家的最新，最高成绩，以便显示
  def update_game_player_score
    #更新最新成绩
    game_player.update_attribute :score, self.score

    #更新最高成绩
    if game_player.best_game_result.nil?
      self.is_best = true
      self.save
    else
      best_game_result = game_player.best_game_result
      i = self.compare( best_game_result)
      if i>0
        best_game_result.update_attribute :is_best, false
        self.update_attribute :is_best, true
      end
    end
  end



  #评估分数是否正确
  def evaluate_trail_score
    game  = game_player.game_round.game
    self.trail_score =  game.evaluate_score( self )

    if self.trail_score != self.score
      self.status = self.class.statuses[:question]
    end
  end
end
