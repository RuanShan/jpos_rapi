class GameResultsController < ApplicationController
  before_action :set_game_player
  before_action :set_game_result, only: [:show, :edit, :update, :destroy]

  # GET /game_results
  # GET /game_results.json
  def index
    @game_results = GameResult.all
  end

  # GET /game_results/1
  # GET /game_results/1.json
  def show
  end

  # GET /game_results/new
  def new
    @game_result = GameResult.new
  end

  # GET /game_results/1/edit
  def edit
  end

  # POST /game_results
  # POST /game_results.json
  def create
    @game_result = GameResult.new(game_result_params)
    @game_result.game_player = @game_player
    @game_result.game_round_id = @game_player.game_round_id

    respond_to do |format|
        if  @game_result.save
          format.html { redirect_to @game_result, notice: 'Game result was successfully created.' }
          format.json { render :show, status: :created, location: @game_result }
        else
          format.html { render :new }
          format.json { render json: @game_result.errors, status: :unprocessable_entity }
        end
      
    end
  end

  # PATCH/PUT /game_results/1
  # PATCH/PUT /game_results/1.json
  def update
    respond_to do |format|
      if @game_result.update(game_result_params)
        format.html { redirect_to @game_result, notice: 'Game result was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_result }
      else
        format.html { render :edit }
        format.json { render json: @game_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_results/1
  # DELETE /game_results/1.json
  def destroy
    @game_result.destroy
    respond_to do |format|
      format.html { redirect_to game_results_url, notice: 'Game result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_game_player
      #如果创建用户
      game_player_id = session[:game_player_id]
      #如果没有创建用户
      if game_player_id.present?
        @game_player = GamePlayer.where( id: game_player_id ).first
      end
      #用户第一次创建成绩时，session[:game_player_id] 为空
      if @game_player.nil?
        openid = session[:openid]
        game_round_id = session[:game_round_id]
        @game_player = GamePlayer.find_or_create_by!( game_round_id: game_round_id, openid: openid  )
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_game_result
      @game_result = GameResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_result_params

      params.require(:game_result).permit(:score, :game_player_id, :trail, :realname, :cellphone, :memo, \
        :delivery_room, :delivery_cellphone, :delivery_time_option, :delivery_time_at, :delivery_sms, :delivery_sms_option, :delivery_sms_at )
    end
end
