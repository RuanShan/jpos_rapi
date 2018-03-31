#实现游戏过程中，游戏个体玩家与服务器之间的交互操作。
class GamePlayersController < ApplicationController
  before_action :set_game_player, only: [:show, :edit, :update, :play_again, :award, :score]
  wechat_api


  # GET /game_players/1
  # GET /game_players/1.json
  def show
  end

  # GET /game_players/new
  def new
    @game_player = GamePlayer.new
  end

  # GET /game_players/1/edit
  def edit
  end

  # POST /game_players
  # POST /game_players.json
  def create
    #每个玩家每个游戏，每个店铺，只需注册一次。
    @game_player = GamePlayer.find_or_initialize_by(game_player_params.slice(:openid, :store_id, :game_round_id))
    @game_player.assign_attributes( game_player_params )
    if params[:base64_image].present?
      @game_player.wedding_photo||= @game_player.build_wedding_photo(  )
      @game_player.wedding_photo.base64_image = params[:base64_image]
    end
    respond_to do |format|
      if @game_player.save
        format.html { redirect_to @game_player, notice: 'Game lucky user was successfully created.' }
        format.json { render :show, status: :created, location: @game_player }
      else
        format.html { render :new }
        format.json { render json: @game_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_players/1
  # PATCH/PUT /game_players/1.json
  def update
    respond_to do |format|
      updated = true

      if @game_player.game_round.end_at.present?
        if DateTime.current <= @game_player.game_round.end_at
          updated = @game_player.update(game_player_params)
        end
      end

      if updated
        format.html { redirect_to @game_player, notice: 'Game lucky user was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_player }
      else
        format.html { render :edit }
        format.json { render json: @game_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # 玩家点击再玩一次，以最后一次成绩为准
  #def play_again
  #  @game_player = @game_player.dup
  #  @game_player.score = 0
  #  @game_player.rank = 0
  #  respond_to do |format|
  #    if @game_player.save
  #      cookies.signed_or_encrypted[:game_player_id] = @game_player.id
  #      format.json { render :show, status: :created }
  #    else
  #      format.json { render json: @game_player.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  #查看当前用户的中奖情况
  def award
    @game_award = @game_player.game_awards.first
  end

  #更新分数
  def score
    game_result_params = game_player_score_params

    game_result = @game_player.game_results.build(game_result_params)
    game_result.ip = request.ip

    if game_result.save
      #取得最新排名和排名%
      #@wx_card_ext = wechat.api_ticket.card_ext
      render :score, status: :ok, location: @game_player
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_player
      @game_player = GamePlayer.find( params[:id] )
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_player_params
      params.require(:game_player).permit( :birth, :realname, :cellphone, :openid,:store_id, :game_round_id,  wedding_photo_attributes: [:type, :base64_image]  )
    end


    def game_player_score_params
      premitted_params = params.require(:game_result).permit( :start_at, :score, trail: {} )
      Rails.logger.debug "Digest::MD5.hexdigest( premitted_params[:score].to_s+ GamePlayer::Salt )=#{Digest::MD5.hexdigest( premitted_params[:score].to_s+ GamePlayer::Salt )}"
      unless Digest::MD5.hexdigest( premitted_params[:score].to_s+ GamePlayer::Salt )  == params['code']
        premitted_params[:memo] = "fake score#{premitted_params[:score]} for incorrect code"
        premitted_params[:score]=0
      end
      premitted_params
    end
end
