class SocketResult::GameAwardPlayer < SocketResult::Base
  #game_award_player, :id, :scores
  #game_award_player.game_player, :nickname, :avatar
  #game_award  :id, :name, :prize_name)

  attr_accessor :state,  :game_round,  :game_award_player, :game_award

  def initialize( action, game_round,  award_player)
    super()
    self.action = action
    self.state = game_round.aasm_state
    self.game_round = game_round
    self.game_award_player = build_game_award_player(award_player )
    self.game_award = award_player.game_award
  end


  def build_game_award_player(award_player )
    award_player.slice(:id, :scores).merge( award_player.game_player.slice( :nickname, :avatar) )
  end
end
