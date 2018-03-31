class GameAwardPlayersController < ApplicationController
  before_action :set_game_award_player, only: [:show, :edit, :update, :destroy]

  # GET /game_award_players
  # GET /game_award_players.json
  def index
    @game_award_players = GameAwardPlayer.all
  end

  # GET /game_award_players/1
  # GET /game_award_players/1.json
  def show
  end

  # GET /game_award_players/new
  def new
    @game_award_player = GameAwardPlayer.new
  end

  # GET /game_award_players/1/edit
  def edit
  end

  # POST /game_award_players
  # POST /game_award_players.json
  def create
    @game_award_player = GameAwardPlayer.new(game_award_player_params)

    respond_to do |format|
      if @game_award_player.save
        format.html { redirect_to @game_award_player, notice: 'Game award user was successfully created.' }
        format.json { render :show, status: :created, location: @game_award_player }
      else
        format.html { render :new }
        format.json { render json: @game_award_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_award_players/1
  # PATCH/PUT /game_award_players/1.json
  def update
    respond_to do |format|
      if @game_award_player.update(game_award_player_params)
        format.html { redirect_to @game_award_player, notice: 'Game award user was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_award_player }
      else
        format.html { render :edit }
        format.json { render json: @game_award_player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_award_players/1
  # DELETE /game_award_players/1.json
  def destroy
    @game_award_player.destroy
    respond_to do |format|
      format.html { redirect_to game_award_players_url, notice: 'Game award user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_award_player
      @game_award_player = GameAwardPlayer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_award_player_params
      params.require(:game_award_player).permit(:game_player_id, :award_level, :award_code)
    end
end
