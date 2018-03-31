module GameRoundAasmState

  extend ActiveSupport::Concern
  included do
    include AASM
    enum aasm_state: { created: 0, open:1, ready: 2, starting: 3, started: 5, completed: 10, disabled: 4 }
    define_aasm_state
  end

  class_methods do

    def define_aasm_state
      aasm :column => :aasm_state, :enum => true do
        state :created, :initial => true
        state :open  # 开始签到
        state :ready # 结束签到，准备开始
        state :starting
        state :started
        state :completed
        state :disabled

        after_all_transitions :handle_cache_service

        # 对公共开放签到
        event :publish do
          transitions :from => :created, :to => :open
        end

        # 结束签到
        event :prepare do
          before do
            self.close_at = DateTime.current
          end
          transitions :from => [:created, :open], :to => :ready
        end

        #开始前倒计时
        event :count_down do
          before do
            self.start_at = DateTime.current.advance seconds:5
            self.end_at = self.start_at.advance seconds: self.duration
          end
          transitions :from => :ready, :to => :starting

        end

        #开始游戏
        event :start do
          transitions :from => :starting, :to => :started
        end

        event :complete do
          transitions :from => :started, :to => :completed
        end

        #重新开始游戏，保存上次游戏结果，结束的游戏才能重新开始
        event :restart do
          before do
            self.cache_free_at = nil
            self.play_times+=1
          end
          transitions :from => :completed, :to => :open
        end

        #重置当前游戏
        event :reset do
          before do
            self.cache_free_at = nil
            self.play_times = 0
            self.award_times = 0
          end
          transitions :from => [ :created, :open, :ready, :starting, :started, :completed ], :to => :open
          success do
            game_award_players.delete_all
            game_players.delete_all
          end
        end

        #重置当前游戏抽奖
        event :reset_prize do
          before do
            self.cache_free_at = nil
          end
          transitions :from => [ :created, :open, :ready, :starting, :started, :completed ], :to => :ready
          success do
            game_award_players.delete_all
          end
        end

      end

    end

  end


  def handle_cache_service
    if self.game_code == 'counting'
      case aasm.current_event
        when :count_down,:count_down!  #count_down, count_down!
          #初始化游戏玩家缓存数据
          PlayerCacheService.init( self )
        when :complete, :complete!
          #计划任务把玩家缓存数据存入数据库
          ClearGameCacheJob.perform_later( self.id, self.play_times)
        when :restart, :restart!
          PlayerCacheService.reset( self )
        when :reset, :reset!
          PlayerCacheService.reset( self )
      end
    end
  end
end
