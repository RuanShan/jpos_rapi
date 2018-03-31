class Api::V1::GameAwardPlayersController < Api::V1::BaseController
  before_action :set_game_award, only: [:index]
  before_action :set_game_award_player, only: [:show, :edit, :update, :destroy]

  def index
    @game_award_players = @game_award.game_award_players.includes(:game_player,:game_award)
  end

  # POST /game_award_players
  # POST /game_award_players.json
  #$ curl -i -X POST -d "game_award_player[game_player_id]=1&game_award_player[game_award_id]=1" http://localhost:3000/api/v1/game_award_players.json?
  def create
    @game_award_player = GameAwardPlayer.new(game_award_player_params)

    respond_to do |format|
      if @game_award_player.save
         format.json { render :show, status: :created, location: @game_award_player }
      else
         format.json { render json: @game_award_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_award_players/1
  # DELETE /game_award_players/1.json
  def destroy
    @game_award_player.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
  def set_game_award
    @game_award = GameAward.find(params[:game_award_id])
  end

   # Use callbacks to share common setup or constraints between actions.
  def set_game_award_player
    @game_award_player = GameAwardPlayer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def game_award_player_params
    params.require(:game_award_player).permit(:game_round_id, :game_player_id, :game_award_id, :scores)
  end
end
