class GameRoundChannel < ApplicationCable::Channel
  attr_accessor :current_game_round

  def subscribed
    stream_for find_game_round
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def game_state(data)
    game_round = find_game_round
    Rails.logger.debug "params = #{params} data=#{data} game_round=#{game_round.inspect}"
    transmit build_result_wrapper( data['action'] )
  end

  #重置游戏
  def reset(data)
    game_round = find_game_round
    game_round.reset!
    transmit build_result_wrapper( data['action'] )
  end

  #结束报名
  def prepare(data)
    game_round = find_game_round
    game_round.prepare!
    GameRoundChannel.broadcast_to( game_round, build_result_wrapper( data['action'], game_round ))
    #current_user.appear(on: data['appearing_on'])
  end

  #游戏开始前的倒计时
  def count_down(data)
    game_round = find_game_round
    game_round.count_down!
    GameRoundChannel.broadcast_to( game_round, build_result_wrapper( data['action'], game_round ))
  end

  # 同步游戏开始前倒计时
  def sync_cd( data )
    game_round = find_game_round
    result = build_result_wrapper( data['action'], game_round )
    result.seconds = data['cd'].to_i
    GameRoundChannel.broadcast_to( game_round, result)
  end

  #开始游戏
  def start(data)
    game_round = find_game_round
    game_round.start!
    Rails.logger.debug "start=#{game_round.inspect}"
    GameRoundChannel.broadcast_to( game_round, build_result_wrapper( data['action'], game_round ))
  end

  #结束游戏
  def complete(data)
    game_round = find_game_round
    game_round.complete!
    Rails.logger.debug "complete=#{game_round.inspect}"
    GameRoundChannel.broadcast_to( game_round, build_result_wrapper( data['action'], game_round ))
  end

  #開始下一局
  def restart(data)
    game_round = find_game_round
    game_round.restart!
    transmit build_result_wrapper( data['action'] )

  end

  def touch_count( data )
    game_round = find_game_round
    game_player = current_player
    new_score = data['score'].to_i
    Rails.logger.debug "params = #{params} data=#{data} game_round=#{game_round.aasm_state}"
    if game_round.started?
      PlayerCacheService.update_score( game_round, game_player, new_score )
    end
  end

  def rank( data )
    game_round = find_game_round

    players = PlayerCacheService.get_ranked_players( game_round )
    Rails.logger.debug "#{players.inspect} "
    #user_id, user_name, user_avatar,score
    action_name = data['type']== 'final' ? 'final_rank' : data['action']
    transmit SocketResult::GameRoundRank.new( action_name, game_round, players)
  end

  #取得下一个签到的用户
  def next_player(data)
    game_round = find_game_round
    #当前position
    position = data['position'].to_i
    game_player = game_round.current_players.where( ["position>?", position]).first

    transmit SocketResult::NextPlayer.new(data['action'], game_round, game_player)
  end

  # load players before starting
  #def load_players( data )
  #  game_round = find_game_round
  #  game_player = game_round.current_players
  #  transmit SocketResult::GamePlayers.new(action_name, game_round, players)
  #end

  def player_info( data )
    game_round = find_game_round
    player = current_player
    Rails.logger.debug " current_player=#{current_player.inspect}"
    PlayerCacheService.player_info( game_round, player )
    transmit SocketResult::PlayerRank.new(data['action'], game_round, player)
  end

  # 重新抽奖
  def restart_award( data )
    game_round = find_game_round
    game_round.reset_prize!
    GameRoundChannel.broadcast_to( game_round, build_result_wrapper( data['action'], game_round ))
  end

  #创建中奖人员
  def award_player( data )
    game_round = find_game_round
    game_award_player_params = { game_round_id: game_round.id }
    game_award_player_params.merge!( data.slice('game_player_id', 'game_award_id' ) )
Rails.logger.debug "data=#{data.inspect} game_award_player_params = #{game_award_player_params.inspect} "
    game_award_player = GameAwardPlayer.create(game_award_player_params)

    transmit SocketResult::GameAwardPlayer.new(data['action'], game_round, game_award_player)
  end

  #取的获奖人员
  def get_awarded_players( data )
    game_round = find_game_round

    award_time = game_round.award_times
    game_player_ids = game_round.game_award_players.where(award_time: award_time).pluck(:game_player_id)
    game_players = game_round.game_players.includes( game_award_players: :game_award).where( id: game_player_ids).order( "game_awards.position, game_award_players.created_at" )

    transmit SocketResult::GameAwardedPlayers.new(data['action'], game_round, game_players)
  end

  def get_noaward_players( data )
    game_round = find_game_round
    game_player_ids = game_round.game_award_players.pluck(:game_player_id)
    game_players = game_round.current_players.where.not( id: game_player_ids)
    transmit SocketResult::GamePlayers.new(data['action'], game_round, game_players)

  end

  #
  def get_players( data )
    game_round = find_game_round

    game_players = game_round.game_players.includes( :game_award)

    transmit SocketResult::GamePlayers.new(data['action'], game_round, game_players)

  end

  private
    def current_player
      if @current_game_player = GamePlayer.find_by(id: params[:game_player_id])
        @current_game_player
      else
        reject_unauthorized_connection
      end
    end

    def find_game_round
     if @current_game_round = GameRound.find_by(id: params[:game_round_id])
       @current_game_round
     else
       reject_unauthorized_connection
     end
    end

    def build_result_wrapper( action_name, data = nil )
      SocketResult::GameRoundState.new(action_name, data || current_game_round)
    end

    def reject_unauthorized_connection
      Rails.logger.error "reject_unauthorized_connection, params:#{params.inspect} "

    end
end
