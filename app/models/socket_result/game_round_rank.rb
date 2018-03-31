class SocketResult::GameRoundRank < SocketResult::Base

  PermittedPlayerAttributes = [:id, :nickname, :avatar, :score, :rank]

  # 目前有两种倒计时情况，开始前的倒计时 和 游戏时间倒计时
  # seconds 表示还有多久结束倒计时
  attr_accessor :state, :t_state, :game_round, :seconds, :game_players

  def initialize( action, game_round, game_players)
    super()
    self.action = action
    self.state = game_round.aasm_state
    self.t_state = game_round.t_state

    self.game_round = game_round
    self.seconds = 0
    self.game_players = game_players.as_json( only: PermittedPlayerAttributes )

  end
end
