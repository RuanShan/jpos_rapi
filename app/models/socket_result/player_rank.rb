class SocketResult::PlayerRank < SocketResult::Base
  PermittedPlayerAttributes = [:id, :avatar, :nickname, :position, :score, :rank ]

  attr_accessor :state, :position, :game_player

  def initialize( action, game_round, game_player)
    super()
    self.action = action
    self.state  = game_round.aasm_state
    #game_player maybe nil
    self.game_player = game_player.as_json( only: PermittedPlayerAttributes )
  end
end
