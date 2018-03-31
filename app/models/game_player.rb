#对于快递，同一个openid可能会有多次。
class GamePlayer < ApplicationRecord
  Salt = '!%0505^&2?zc'
  include AASM
  extend DisplayDateTime
  #玩家签到是，按照position顺序显示
  acts_as_list scope: [:game_round_id]

  belongs_to :game_round
  belongs_to :wechat_account

  # 一个客户在一个游戏中，可能得多个奖，现金红包+卡券
  has_many :game_award_players
  has_many :game_awards, through: :game_award_players
  has_many :votes
  has_many :game_days
  has_many :game_results, inverse_of: :game_player
  has_one  :best_game_result, ->{ where is_best:true }, class_name: 'GameResult'
  has_one :game_today, ->{ where( day: DateTime.current.to_date ) }, class_name: "GameDay"

  has_one :wedding_photo, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :wedding_photo

  scope :by_round, ->(game_round) { where(game_round_id: game_round.id) }
  scope :rank, ->(game_round) { by_round(game_round ).order( score: :desc) }
  scope :rank_by_max, ->(game_round) { by_round(game_round ).order( max_score: :desc) }
  scope :name_like, ->(term) {  where( ["game_players.realname LIKE ? OR game_players.nickname LIKE ? ", "%#{term}%", "%#{term}%"]) }

  date_time_methods :created_at, :updated_at

  validates :cellphone, format: { with: /[0-9]{11}/ }, length: { is: 11}, allow_blank: true

  # verifyied： 用户数入手机和姓名
  enum aasm_state:{ created: 0, verified: 5, permitted: 1, denied: 2}

  aasm :column => :aasm_state, :enum => true do
    state :created, :initial => true
    state :verified
    state :permitted

    event :verify do
      # player.dup.save  player state may be verified
      transitions :from => [:created, :verified], :to => :verified
    end

    after_all_transitions :handle_channel_service

  end

  #validate :check_game_round_end_time
  before_create :verify_contact
  before_save :save_max_score
  after_save :win_prize_after_game
  before_create :generate_score_token


  # return integer reprasent percent of position
  def percent_position
    total_count = GamePlayer.where( [ "game_round_id=? ", game_round_id]).count
    (current_position.to_f/total_count * 100).to_i
  end

  #返回玩家当前得分排名, 以最高分进行排名统计
  def current_position
    if best_game_result.present?
      #游戏排名得分数相同情况下，以得分挑战用时最短者优先排名；如游戏得分及挑战时间相同，以先达到者优先排名；
      #找到比他成绩好的
      i = GameResult.where( [ "game_round_id=? and score>? and is_best", game_round_id, max_score]).count
      #玩家的相同成绩
      game_results = GameResult.where( game_round_id: game_round_id, score: max_score, is_best: true )
      better_game_results = game_results.select{|gr| gr.compare( best_game_result) >0 }

      i + better_game_results.count + 1
      #找出每个玩家的最高成绩
    else
      GamePlayer.where( [ "game_round_id=? ", game_round_id]).count
    end

  end

  def age
    #25岁之前—心动系列
    #26-30岁—360°爱系列
    #31-35岁—真爱加冕系列
    #36岁以后—纪念日系列
    self.birth.blank? ? 0 : (Date.today.year - self.birth.year)
  end

  #是否可以抽奖
  def lot_prize_available?
    available = false
    game_awards = self.game_round.game_awards.taxon_lot
    game_awards.each{| game_award |
      if game_award.available_to?( self )
        available = true
        break
      end
    }
    available
  end

  def reset_score_token!
    generate_score_token
    save
  end


  private
  def verify_contact
    # change to verified
    self.verify
  end

  def handle_channel_service
    #case aasm.current_event
    #  when :verify,:verify!
    #    CheckInNotifyService.new( self ).call
    #end
  end

  def save_max_score
    self.max_score = self.score if self.score > self.max_score
  end

  def win_prize_after_game
    #如果分数改变了，检查是否得奖
    if saved_change_to_attribute? 'score'
      game_round.game_awards.each{| game_award|

      }
    end
  end

  def check_game_round_end_time
    #如果分数改变，检查是否在游戏时间内？
    if score_changed?
      if self.game_round.end_at.present?
        Rails.logger.debug "current:#{DateTime.current}, game_round.end:#{ self.game_round.end_at } "
        errors.add(:score, '游戏已结束，无法更新成绩') if DateTime.current > self.game_round.end_at
      end
    end
  end

  def generate_score_token
      self.score_token = SecureRandom.base64(32)
  end

end
