# open_at: 游戏开放时间，即预热开始时间，开放时间以前，不允许访问
# close_at: 游戏关闭时间
# start_at: 游戏开始时间，这个时间点开始，客户可以玩游戏。
# end_at: 游戏结束时间，这个时间点以后，客户不可以玩游戏。
class GameRound < ApplicationRecord
  extend DisplayDateTime
  date_time_methods :start_at, :end_at

  include GameRoundAasmState

  belongs_to :creator, class_name: 'User'
  belongs_to :campaign
  belongs_to :game

  has_one :logo, class_name: 'GameRoundLogo'
  has_one :mobile_background, class_name: 'ScreenaBackground'
  has_one :screen_background, class_name: 'ScreenbBackground'
  # game
  has_many :game_players, dependent: :delete_all

  has_many :game_award_players, dependent: :delete_all
  has_many :game_awards
  has_many :game_results

  scope :check_in, ->{ where game: Game.check_in.first }

  scope :by_code, ->(code){ where game: Game.where(code: code).first }

  #serialize :award_counts, JSON
  #关键字"1、0、b、c"为系统默认关键字,暂不可用
  accepts_nested_attributes_for :game_awards, :screen_background, :mobile_background, :logo, allow_destroy: true


  validates_presence_of :game
  validates_numericality_of :duration, only_integer: true, greater_than: 0, if: :game_code_counting?

  delegate :code, :code_check_in?, :code_counting?, to: :game, prefix: true, allow_nil: true

  before_validation :set_default_value
  after_validation :fix_aasm_state


  # position start from 1
  def build_game_award_by_position( i )
    hans = ['一', '二', '三', '四', '五']
    game_awards.build( position: i, name: "#{hans[i-1]}等奖" )
  end


  def attributes_for_player
    cols = ['id', 'campaign_id', 'contact_required', 'duration']
    attributes.slice( *cols )
  end

  def seconds_to_start
    seconds = 0
    if starting? && start_at.future?
      seconds = start_at.to_i - DateTime.current.to_i
    end
    seconds
  end

  def seconds_to_complete
    seconds = 0
    if started? && end_at.future?
      seconds = end_at.to_i - DateTime.current.to_i
    end
    seconds
  end

  def t_state
    case aasm_state
      when 'created'
        "游戏还未开放"
      when 'open'
        "游戏报名中"
      when 'ready'
        "游戏报名结束，准备开始"
      when 'starting'
        "游戏开始倒计时"
      when 'started'
        "游戏中"
      when 'completed'
        "游戏已结束"
      else
        aasm_state
    end
  end

  # 计划任务会使用这个方法，并传入 play_times
  # 对于数钱游戏，需要知道排名，但是实时数据在redis里
  # params
  # rank:
  # page:
  # page_size
  # play_times
  def current_players( options = {} )

    query = GamePlayer.where( game_round_id: self.id)
  end

  #游戏是否对大众开放
  def opening?
    self.close_at.present? && self.close_at.future?
  end


  private
  def set_default_value
    #for unknown reason, can not set default value for these column, so set it here.
    self.duration = 0 if self.duration.nil?
    self.gear = 0 if self.gear.nil?
  end

  def  fix_aasm_state
    if open_at_changed? && open_at.present? && open_at.past?
      self.publish
    end
  end

end
