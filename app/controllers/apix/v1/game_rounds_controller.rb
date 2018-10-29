class Api::V1::GameRoundsController <  Api::V1::BaseController

  before_action :set_game_round, only: [ :show, :edit, :update, :destroy, :reset, :restart_award]

  # curl -i http://localhost:3000/api/v1/game_rounds?per_page=4\&q_code=check_in
  # curl -i -X GET http://localhost:3000/api/v1/game_rounds
  # GET /game_rounds.json
  def index
    query = GameRound.all
    if params[:q_code].present?
      query = query.where( code: params[:q_code] )
    end
    @game_rounds = paginate query
  end

  #
  def reset
    @game_round.reset!
  end

  def restart_award
    #@game_round.game_award_players.clear
    @game_round.award_times+=1
    @game_round.save
  end


  #開始遊戲
  def start
    if @game_round.ready?
      #@game_round.started!
    end
  end

  def game_state

  end

  # curl -i -X GET http://localhost:3000/api/v1/game_rounds/1
  # GET /game_rounds/1.json
  # {"game_round":{"id":1,"name":"六一儿童节快乐联欢","contact_required":false,"display_players":0,"duration":0,"play_times":0,"award_times":0,"start_at":null,"end_at":null,"created_at":"2017-05-20T15:29:06.000+08:00"}}
  def show
  end

  # GET /game_rounds/new
  def new
    @game_round = GameRound.new
  end

  # GET /game_rounds/1/edit
  def edit
  end

  #
  # POST /game_rounds.json
  # game_round[name]=测试
  # game_round[awards]=5
  # game_round[code]=check_in
  # game_round[contact_required]=0
  # game_round[game_awards_attributes][0][name]=一等奖
  # game_round[game_awards_attributes][0][position]=1
  # game_round[game_awards_attributes][0][prize_count]=0
  # game_round[game_awards_attributes][1][name]=二等奖
  # game_round[game_awards_attributes][1][position]=2
  # game_round[game_awards_attributes][1][prize_count]=0
  # game_round[game_awards_attributes][2][name]=三等奖
  # game_round[game_awards_attributes][2][position]=3
  # game_round[game_awards_attributes][2][prize_count]=0
  # game_round[game_awards_attributes][3][name]=四等奖
  # game_round[game_awards_attributes][3][position]=4
  # game_round[game_awards_attributes][3][prize_count]=0
  # game_round[game_awards_attributes][4][name]=五等奖
  # game_round[game_awards_attributes][4][position]=5
  # game_round[game_awards_attributes][4][prize_count]=0

  # "game_round"=>{"game_id"=>"1", "name"=>"this is new game", "contact_required"=>"1", "awards"=>"4",
  #   "game_awards_attributes"=>{"0"=>{"name"=>"一等奖", "position"=>"1", "prize_count"=>"1"},
  #                              "1"=>{"name"=>"二等奖", "position"=>"2", "prize_count"=>"2"},
  #                              "2"=>{"name"=>"三等奖", "position"=>"3", "prize_count"=>"3"},
  #                              "3"=>{"name"=>"四等奖", "position"=>"4", "prize_count"=>"0"},
  #                              "4"=>{"name"=>"五等奖", "position"=>"5", "prize_count"=>"0"}}}
  #$ curl -i -X POST -d "game_round[name]=六一儿童节快乐联欢" http://localhost:3000/api/v1/game_rounds.json
  #{"game_round":{"id":7,"name":"六一儿童节快乐联欢","contact_required":false,"display_players":0,"duration":0,"play_times":0,"award_times":0,"start_at":null,"end_at":null,"created_at":"2017-05-24T11:06:31.000+08:00"}}

  #$ curl -i -X POST -d "game_round[name]=六一儿童节快乐联欢&game_round[game_awards_attributes][0][name]=一等奖&game_round[game_awards_attributes][0][prize_count]=2" http://localhost:3000/api/v1/game_rounds.json
  # {"status":"unprocessable_entity","errors":[{"title":"不能为空字符","detail":"不能为空字符","source":{"pointer":"data/attributes/game"}}]}
  def create
    @game_round = GameRound.new(game_round_params)
      if @game_round.save
        render :show, status: :created, location: @game_round
      else
        invalid_resource!( @game_round )
      end
  end

  # curl -i -X POST -d "game_round[name]=这是一个最新数钱游戏&game_round[game_awards_attributes][0][name]=最新一等奖&game_round[game_awards_attributes][0][id]=31" http://localhost:3000/api/v1/game_rounds.json
  # PATCH/PUT /game_rounds/1.json
  def update
      if @game_round.update(game_round_params)
        render :show, status: :ok, location: @game_round
      else
        invalid_resource!( @game_round )
      end
  end

  # DELETE /game_rounds/1.json
  # curl -i -X DELETE http://localhost:3000/api/v1/game_rounds/7
  def destroy
    @game_round.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_round
      @game_round = GameRound.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_round_params
      params.require(:game_round).permit(:aasm_state, :code, :appid, :name,:display_players, :contact_required, :gear, :start_at, :end_at, :duration, :wx_keyword,
        game_awards_attributes:  [ :id,  :name, :position, :prize_count, :prize_name, :_destroy  ] )
    end

end
