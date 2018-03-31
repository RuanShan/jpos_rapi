class GameDaysController < ApplicationController
  before_action :set_game_day, only: [:show, :edit, :update, :destroy]

  # GET /game_days
  # GET /game_days.json
  def index
    @game_days = GameDay.all
  end

  # GET /game_days/1
  # GET /game_days/1.json
  def show
  end

  # GET /game_days/new
  def new
    @game_day = GameDay.new
  end

  # GET /game_days/1/edit
  def edit
  end

  # POST /game_days
  # POST /game_days.json
  def create
    @game_day = GameDay.new(game_day_params)

    respond_to do |format|
      if @game_day.save
        format.html { redirect_to @game_day, notice: 'Game day was successfully created.' }
        format.json { render :show, status: :created, location: @game_day }
      else
        format.html { render :new }
        format.json { render json: @game_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_days/1
  # PATCH/PUT /game_days/1.json
  def update
    respond_to do |format|
      if @game_day.update(game_day_params)
        format.html { redirect_to @game_day, notice: 'Game day was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_day }
      else
        format.html { render :edit }
        format.json { render json: @game_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_days/1
  # DELETE /game_days/1.json
  def destroy
    @game_day.destroy
    respond_to do |format|
      format.html { redirect_to game_days_url, notice: 'Game day was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_day
      @game_day = GameDay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_day_params
      params.require(:game_day).permit(:game_player_id, :day, :play_count, :share_count)
    end
end
