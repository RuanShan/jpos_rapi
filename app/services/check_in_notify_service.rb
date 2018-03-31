class CheckInNotifyService
  attr_accessor :game_player

  def initialize( game_player )
    self.game_player = game_player
  end

  def call
    data = {action:'check_in', game_player: game_player }
    GameRoundChannel.broadcast_to( game_player.game_round, data )
  end
end
