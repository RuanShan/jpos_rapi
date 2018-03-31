class Api::V1::GameAwardsController  < Api::V1::BaseController
  before_action :set_game_round, only: [:index]
  before_action :set_game_award, only: [:show, :edit, :update, :destroy]

  # get game_awards by game_round_id
  # curl -i -X GET http://localhost:3000/api/v1/game_rounds/1/awards
  # {"game_awards":[{"id":1,"name":"一等奖","position":1,"prize_count":1,"prize_name":""},{"id":2,"name":"二等奖","position":2,"prize_count":2,"prize_name":""},{"id":3,"name":"三等奖","position":3,"prize_count":3,"prize_name":""},{"id":4,"name":"四等奖","position":4,"prize_count":0,"prize_name":""},{"id":5,"name":"五等奖","position":5,"prize_count":0,"prize_name":""}]}
  def index
     @game_awards =  @game_round.game_awards
  end

  # curl -i -X POST -d "game_award[game_round_id]=1&game_award[name]=一等奖&game_award[prize_count]=2&game_award[prize_name]=小米6" http://localhost:3000/api/v1/game_awards
  #{"game_award":{"id":7,"name":"六一儿童节快乐联欢","contact_required":false,"display_players":0,"duration":0,"play_times":0,"award_times":0,"start_at":null,"end_at":null,"created_at":"2017-05-24T11:06:31.000+08:00"}}
  def create
    @game_award = GameAward.new(game_award_params)
      if @game_award.save
        render :show, status: :created, location: @game_award
      else
        invalid_resource!( @game_award )
      end
  end

  # curl -i -X PUT -d "game_award[position]=1game_award[prize_count]=3&game_award[prize_name]=小米7" http://localhost:3000/api/v1/game_awards/31
  # PATCH/PUT /game_awards/1
  def update
      if @game_award.update(game_award_params)
        render :show, status: :ok, location: @game_award
      else
        invalid_resource!( @game_award )
      end
  end

  # DELETE /game_awards/1.json
  # curl -i -X DELETE http://localhost:3000/api/v1/game_awards/7
  # HTTP/1.1 204 No Content
  def destroy
    @game_award.destroy
    head :no_content
  end

  private
  def set_game_round
    @game_round = GameRound.find(params[:game_round_id])
  end

  def set_game_award
    @game_award = GameAward.find(params[:id])
  end

  def game_award_params
    params.require(:game_award).permit(:id,  :name, :position, :prize_count, :prize_name, :game_round_id)
  end
end
