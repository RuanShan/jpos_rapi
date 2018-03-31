class SocketResult::GameAwardPlayers < SocketResult::Base
  #game_award_player, :id, :scores
  #game_award_player.game_player, :nickname, :avatar
  #game_award  :id, :name, :prize_name)

  attr_accessor :state,  :game_round,  :game_award_player, :game_award

  def initialize( action, game_round, award_players)
    super()
    self.action = action
    self.state = game_round.aasm_state
    self.game_round = game_round
    self.game_award_players = award_players.map{|player| build_game_award_player(player )}
    self.game_award = game_award_player
  end



  def build_game_award_player(award_player )
    award_player.slice(:id, :scores).merge( award_player.game_player.slice( :nickname, :avatar) )
  end
end
