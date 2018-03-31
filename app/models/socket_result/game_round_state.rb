class SocketResult::GameRoundState < SocketResult::Base
  PermittedAttributes = [:state, :start_at, :end_at]

  # 目前有两种倒计时情况，开始前的倒计时 和 游戏时间倒计时
  # seconds 表示还有多久结束倒计时
  attr_accessor :state, :t_state, :game_round, :seconds

  def initialize( action, game_round)
    super()
    self.action = action
    self.state = game_round.aasm_state
    self.t_state = game_round.t_state
    self.game_round = game_round
    self.seconds = 0
    self.seconds = game_round.seconds_to_complete if game_round.started?
    self.seconds = game_round.seconds_to_start if game_round.starting?
  end


end
