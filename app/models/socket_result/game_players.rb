class SocketResult::GamePlayers < SocketResult::Base

  PermittedAttributes = [:state, :start_at, :end_at]

  # 目前有两种倒计时情况，开始前的倒计时 和 游戏时间倒计时
  # seconds 表示还有多久结束倒计时
  attr_accessor :state,  :game_round,  :game_players

  def initialize( action, game_round, game_players)
    super()
    self.action = action
    self.state = game_round.aasm_state
    self.game_round = game_round
    self.game_players = game_players

  end
end
