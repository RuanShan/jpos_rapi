class GameLogController < ApplicationController
  before_action :set_game_player!, only: [:hdgame]
  #gameType: 0:
  #          1: 必须报名

  def log_ajax_error
    r = {rt: 0}
    render plain:  r.to_json
  end

  def log
    # dogId=1000028, jin ru you xi
    r = {rt: 0}
    render plain:  r.to_json
  end

  def log_js_error
    r = {rt: 0}
    render plain:  r.to_json
  end

  def hdgame
    cmd = params[:cmd]
      r = { rt: 0, isSuc: true, success: true }

      case cmd
      when  'setAchieve'     #设置成绩
        last_max_score = @game_player.max_score
        game_result = set_achieve
        r[:playerId] = @game_player.id #required to set g_config.playerId
        r[:isSuc] = game_result.score >  last_max_score
        r[:achieveToken]= @game_player.score_token
        r[:score] = @game_player.max_score  #bestScore
        r[:rank] = @game_player.current_position
        r[:beat] = 100 - @game_player.percent_position
        r[:hasLot] =  @game_player.lot_prize_available?
      when 'getRankList' #排行榜
        r.merge!( get_rank_list )
      when 'joinGameBehavior'
        session[:game_start_at] = DateTime.current
        join_game_behavior

      when 'getGiftList' #我的奖品

        list = []
        awardModel = {awardtype:1,cbt:DateTime.current.to_s, cet:DateTime.current.to_s, deadline:'这是使用期限'}
        # 0: 未领"; 1:已核销 2:未核销 3:已过期 4:已作废 5:已失效
        award = { anwei: false, awardLevel: 0, level: 1, codeStatus: 0, awardCode: 'awardCode', awardStyle:'几等奖', awardName:'奖品名称', awardInfo: awardModel.to_json }
        list.push( award )
        r[:list] = list
      when 'getResult'  #取得抽奖结果

        r.merge!( get_result )

      when 'getJoinNum'
        r[:joinNum] = get_join_num
      end
      render plain:  r.to_json
  end

  private

  def set_achieve

    game_result_params = game_player_score_params

    game_result = @game_player.game_results.build(game_result_params)
    game_result.ip = request.ip
    game_result.start_at = session[:game_start_at]
    game_result.save
    game_result
  end

  def get_rank_list
    r = {rank: 0}
    start = params[:start].to_i
    limit = params[:limit].to_i
    @game_round = @game_player.game_round
    game_players = GamePlayer.eager_load( :best_game_result).where( game_round:@game_round ).order(  'game_results.score desc, game_results.time_span asc, game_results.created_at asc ' ).offset( start).limit( limit)
    #game_players = GamePlayer.rank_by_max( @game_round ).offset( start).limit( limit)
    list = game_players.map{|player|
       { name: player.nickname, achievement: player.max_score, scoreUnit: '分', info: {headImg: player.avatar}.to_json }
    }
    r[:rankList] = list
    if @game_player
      r[:rank] = @game_player.current_position
    end
    r[:isRankAll] = ((start+limit) >= @game_round.game_players.count)
    r
  end

  def join_game_behavior
    @game_today = @game_player.game_today
    @game_today.play_count+=1
    @game_today.save
  end

  #取得抽奖结果
  def get_result
    #github/com/bigertech/lottery
    # prize_count
    r = { isSuc: false }
    @game_round = @game_player.game_round
    @game_awards = @game_round.game_awards.taxon_lot
    @game_awards.each{| game_award |
      if game_award.available_to?( @game_player )
Rails.logger.debug "game_award.available_to #{@game_player.nickname}"
        game_award_player = game_award.offer_to( @game_player )

        if game_award_player.present?
          r[:awardStyle] = game_award.name #'几等奖'
          r[:awardName] = game_award.prize_name #'奖品名称'
          r[:awardCode] = '兑奖码'
          r[:awardTypeNum] = ''
          r[:awardIndex] = 1
          r[:awardImageW]='9rem'
          r[:awardImageH]='9rem'
          r[:isSuc] = true
          #r[:rt] = 1 #今天没有抽奖机会了
          #r[:rt] = 13 #您的抽奖机会已经用完
        end
        break
      end
    }
    r
  end

  #有多少玩家
  def get_join_num
    @game_round = @game_player.game_round
    @game_round.game_players.count
  end

  def set_game_player
    # game player could join more than one game_round, openid may same
    playerId = params[:playerId]
    @game_player = GamePlayer.where( id: playerId ).first
  end

  def set_game_player!
    # game player could join more than one game_round, openid may same
    playerId = params[:playerId]
    @game_player = GamePlayer.find( playerId )
  end

  def set_game_round
    # game player could join more than one game_round, openid may same
    gameId = params[:gameId]
    @game_round = GameRound.find( gameId )
  end

  def game_player_score_params
    premitted_params = params.require(:game_result).permit( :game_player_id, :start_at, :score, trail: {} )
    unless build_code( premitted_params[:score].to_s, @game_player.score_token ) == params['code']
      premitted_params[:memo] = "fake score#{premitted_params[:score]} for incorrect code"
      premitted_params[:score]=0
    end
    premitted_params
  end

  def build_code( s, token )
    Rails.logger.debug "Base64.strict_encode64( #{s} + #{ token })"
    code = Base64.strict_encode64('"'+s+'"')+token
    code
  end

end
