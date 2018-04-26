class Api::V1::Statis::UsersController  < Api::V1::BaseController
  before_action :set_game_day, only: [:show, :edit, :update, :destroy]



  # curl -i -X POST -d "game_day[game_day_id]=1&game_day[name]=一等奖&game_day[prize_count]=2&game_day[prize_name]=小米6" http://localhost:3000/api/v1/game_days
  #{"game_day":{"id":7,"name":"六一儿童节快乐联欢","contact_required":false,"display_players":0,"duration":0,"play_times":0,"award_times":0,"start_at":null,"end_at":null,"created_at":"2017-05-24T11:06:31.000+08:00"}}
  def create
    @game_day = GameDay.new(game_day_params)
      if @game_day.save
        render :show, status: :created, location: @game_day
      else
        invalid_resource!( @game_day )
      end
  end

  # curl -i -X PUT -d "game_day[position]=1game_day[prize_count]=3&game_day[prize_name]=小米7" http://localhost:3000/api/v1/game_days/31
  # PATCH/PUT /game_days/1
  def update
      if @game_day.update(game_day_params)
        render :show, status: :ok, location: @game_day
      else
        invalid_resource!( @game_day )
      end
  end

  # DELETE /game_days/1.json
  # curl -i -X DELETE http://localhost:3000/api/v1/game_days/7
  # HTTP/1.1 204 No Content
  def destroy
    @game_day.destroy
    head :no_content
  end

  private

  def set_game_day
    @game_day = GameDay.find(params[:id])
  end

  def game_day_params
    params.require(:game_day).permit(:id,  :name, :position, :prize_count, :prize_name, :game_day_id)
  end
end
