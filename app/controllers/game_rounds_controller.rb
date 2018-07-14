class UnopenGameError < RuntimeError; end

class GameRoundsController < Game::BaseController
  layout :select_layout_by_game

  wechat_api

  before_action :set_game_round
  before_action :set_game_player, except: [:shared, :step, :check_in, :create_tester, :new_player, :create_player, :awards, :result]

  rescue_from ActionController::ParameterMissing do
    head :bad_request
  end
  rescue_from UnopenGameError do |exception|
    render :unopen_game, layout: 'application', status: 404
  end
  #故事类游戏的入口。 如：IDO
  # params
  #   step: 初始化页码
  #   player_id: game_player_id, 分享链接积攒的玩家
  def step
    wechat_oauth2(@wx_oauth2_scope) do |openid, access_info|
      #初始化页，客户分享时，显示相应页面
      # 使用session保存 openid, 创建成绩时使用
      session[:openid] = openid

      @step = params[:step].to_i

      @game_player = GamePlayer.where( game_round: @game_round, openid: openid).first

      @game_player_by_openid = @game_player

      if @game_player
        last_result = @game_player.game_results.last
        if last_result.present?
          @game_result = GameResult.new( realname: last_result.realname, cellphone:  last_result.cellphone, delivery_room: last_result.delivery_room, delivery_cellphone: last_result.delivery_cellphone )
        else
          @game_result = GameResult.new
        end
      else
        @game_result = GameResult.new
      end
    end
  end

  #客户分享的链接
  def shared
    wechat_oauth2(@wx_oauth2_scope) do |openid, access_info|
      #初始化页，客户分享时，显示相应页面
      session[:openid] = openid

      @step = params[:step].to_i
      #检查用户自己是否注册了
      @game_player_by_openid = GamePlayer.where( game_round: @game_round, openid: openid).first
      #用户点击积攒链接进入页面, 为game_player点赞
      @game_player =  GamePlayer.find_by_id(params[:player_id])
      #用户分享结婚照页面，
      @photograph = WeddingPhoto.find_by_id(params[:photo_id])
      if @game_player
        render :step
      else
        #如果 @game_player 为空，无法点赞
        redirect_to action: :step
      end
    end
  end

  def unavailable
    #wechat_user = check_in_params
    #@game_player = GamePlayer.new(   nickname: wechat_user['nickname'], avatar:  wechat_user['headimgurl'] )
  end

  def play
    # TODO 应该把大屏的显示端，和游戏的手机端分别使用不同的action
    if mobile?
      unless @game_player.game_today
        @game_player.create_game_today!( day: DateTime.current.to_date )
      end
    end

    @game_awards = @game_round.game_awards.order(:position)
    @game_player_count = @game_round.current_players.count
    #最後成績顯示用
    if @game_round.code == 'counting'

        if @game_round.cache_free_at.present?
          @game_players = @game_round.current_players.order(  score: :desc )
        else
          @game_players = PlayerCacheService.get_ranked_players( @game_round )
        end
    else
      @game_players = @game_round.current_players
    end
  end

  # 签到、竞技类游戏系统入口
  def check_in

    if mobile?
      #请求签到
      #openid = get_openid
      wechat_oauth2(@wx_oauth2_scope) do |openid, access_info|

        if openid.present?
          session[:openid] = openid

          @game_player = GamePlayer.find_by( game_round_id: @game_round.id, openid: openid, play_time: @game_round.play_times)

          if @game_player.blank?
            if @game_round.contact_required?
              redirect_to new_player_game_round_path( @game_round, openid: openid )
            else
              #@user={"subscribe"=>1, "openid"=>"oK3d3s-Sd3be-t1LVwYNNau4A8Dc", "nickname"=>"try", "sex"=>0, "language"=>"zh_CN", "city"=>"", "province"=>"", "country"=>"", "headimgurl"=>"http://wx.qlogo.cn/mmopen/Q3auHgzwzM61FPBtkpLIFAjB97N4shINzXfGYNyMbs5gQJ0SvEqQw2Pln8WGjHNRfBxwfs1SlicSxkjJeBc4AGnGvDEE8eXk2KTLKwZWHZE4/0", "subscribe_time"=>1492938345, "remark"=>"", "groupid"=>0, "tagid_list"=>[]}
              player_params = { game_round_id: @game_round.id, openid: openid, play_time: @game_round.play_times }
              if @game.snsapi_userinfo?
                #调用 api 获得发送者
                user = wechat.web_userinfo( access_info['access_token'], openid )
                player_params.merge!( { nickname: user['nickname'], avatar:  user['headimgurl'] } )
              end
              @game_player = GamePlayer.create(player_params )
              #存储game_player_id 到session，更新玩家数据时使用
              session[:game_player_id] = @game_player.id
              #重定向到 play, 数钱，抽奖
              redirect_to play_game_round_path( @game_round.id )
            end
          else
            redirect_to play_game_round_path( @game_round.id )
          end

        else
          # 未知情况
          redirect_to root_path
        end
      end
    else
      # 显示 所有用户到大屏幕
      @game_players = @game_round.current_players
    end
  end

  def new_player
    wechat_oauth2(@wx_oauth2_scope) do |openid, access_info|
      user_params = {}
      if @game.snsapi_userinfo?
        user = wechat.web_userinfo( access_info['access_token'], openid )
        user_params.merge!( user )
      end
      @game_player = @game_round.game_players.build( openid: openid, avatar: user_params['headimgurl'] )
    end

  end

  def create_player
    openid = get_openid
    #调用 api 获得发送者
    user = wechat.user( openid )
    player_params = game_player_params
    #@user={"subscribe"=>1, "openid"=>"oK3d3s-Sd3be-t1LVwYNNau4A8Dc", "nickname"=>"try", "sex"=>0, "language"=>"zh_CN", "city"=>"", "province"=>"", "country"=>"", "headimgurl"=>"http://wx.qlogo.cn/mmopen/Q3auHgzwzM61FPBtkpLIFAjB97N4shINzXfGYNyMbs5gQJ0SvEqQw2Pln8WGjHNRfBxwfs1SlicSxkjJeBc4AGnGvDEE8eXk2KTLKwZWHZE4/0", "subscribe_time"=>1492938345, "remark"=>"", "groupid"=>0, "tagid_list"=>[]}
    player_params.merge!( { game_round_id: @game_round.id, openid: openid, play_time: @game_round.play_times } )
    player_params.merge!( { nickname: user['nickname'], avatar:  user['headimgurl'] } )
    @game_player = GamePlayer.create(player_params )

    if @game_player.persisted?
      session[:game_player_id] = @game_player.id

      redirect_to action: :play
    else
      render :new_player
    end

  end

  #開始遊戲
  def start
  end

  #游戏获奖名单
  def awards
    @game_awards = @game_round.game_awards.includes( game_award_players: :game_player )
  end

  #游戏排行榜
  def ranking
    @current_player = @game_round.game_players.find_by( openid: get_openid )

    @game_players = @game_round.game_players.order(rank: :asc, max_score: :desc).limit( 100 )
  end

  def final_rank
    #最後成績顯示用
    if @game_round.code == 'counting'
        if @game_round.cache_free_at.present?
          @game_players = @game_round.current_players.order(  {score: :desc, rank: :asc} )
        else
          @game_players = PlayerCacheService.get_ranked_players( @game_round )
        end
    else
      @game_players = @game_round.current_players
    end
  end

  # GET /game_rounds/1
  # GET /game_rounds/1.json
  def show
    #@game_round.game.

  end


  def create_tester
    openid = 'oK3d3s31SjHM-GySF4GXC2zQediw'
    avatar =  'http://wx.qlogo.cn/mmopen/VX7U0xDSUxiaYgiasax2BWhlFuXmDaGvibY27Zknyy2WWrgNQwHvTfrKicupics0tdlFqBWGicy3heHOyRKPrBvEibFZtHCicf8zyKkr/0'
    tester = @game_round.game_players.find_or_create_by! openid: openid, avatar: avatar
    cookies.signed_or_encrypted[:we_openid] = tester.openid

    redirect_to action: :play
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_round
      @game_round = GameRound.includes(:game).find(params[:id])
      @game = @game_round.game
      @wx_oauth2_scope = @game.wx_oauth2_scope
      #用户当前选择的应用，创建用户成绩时使用
      session[:game_round_id] =  @game_round.id
      raise UnopenGameError unless @game_round.opening?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_round_params
      params.require(:game_round).permit(:game_id, :name, :start_at, :end_at, :preferences)
    end

    def game_player_params
      params.require(:game_player).permit(:realname, :cellphone)
    end


    def set_game_player
      #汽车游戏，用户可能玩多次，每玩一次，我们创建一个GamePlayer,并保存成绩，
      openid = get_openid
      #Rails.logger.debug " cookies openid=#{cookies[:we_openid]} "
      # 使用 mobile? 而不使用wechat? 便于调试。
      if mobile?
        if openid
          # 同一个openid,可能参与多个游戏
          @game_player = GamePlayer.find_by( game_round: @game_round, openid: openid )
        end

        unless @game_player.present?
          # create game_player by params, audi game
          if @game.code_runlin_dumpling? && params[:openid].present?
            game_player_attrs = game_player_params
            game_player_attrs[:game_round] = @game_round
            @game_player = GamePlayer.create(  game_player_attrs  )

          else
            cookies.delete :we_openid
            redirect_to check_in_game_round_path( @game_round.id )
            return
          end
        end
        #设置缓存分数，显示成绩, 只是针对大屏数钱游戏
        PlayerCacheService.player_info(@game_round,@game_player )
        Rails.logger.debug " @game_player=#{@game_player.id}"
      end
    end

    # 基于游戏，选择布局模板。每个游戏功能需求不同，需要相应模板，
    def select_layout_by_game
        case @game.code
        when 'runlin_car_game'
          'game/runlin_car_game'
        when 'runlin_dumpling'
          'game/runlin_dumpling'
        when 'yhzy_smp'
          'yhzy_smp'
        else
          'game_rounds'
        end
    end

    # cardnumber, openid, headimg, nickname,
    def game_player_params
      { cardid: params[:cardnumber], openid: params[:openid], avatar: params[:headimg], nickname: params[:nickname] }
    end
end
