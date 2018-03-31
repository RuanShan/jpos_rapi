class SocketResult::NextPlayer < SocketResult::Base
  PermittedAttributes = [:id, :avatar, :nickname, :position]

  attr_accessor :state, :position, :game_player

  def initialize( action, game_round, game_player)
    super()
    self.action = action
    self.state  = game_round.aasm_state
    #game_player maybe nil
    self.game_player = game_player
  end
end
