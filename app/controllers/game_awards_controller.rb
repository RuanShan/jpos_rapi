class GameAwardsController < ApplicationController
  before_action :set_game_award, only: [:show, :edit, :update, :destroy]

  # GET /game_awards
  # GET /game_awards.json
  def index
    @game_awards = GameAward.all
  end

  # GET /game_awards/1
  # GET /game_awards/1.json
  def show
  end

  # GET /game_awards/new
  def new
    @game_award = GameAward.new
  end

  # GET /game_awards/1/edit
  def edit
  end

  # POST /game_awards
  # POST /game_awards.json
  def create
    @game_award = GameAward.new(game_award_params)

    respond_to do |format|
      if @game_award.save
        format.html { redirect_to @game_award, notice: 'Game award was successfully created.' }
        format.json { render :show, status: :created, location: @game_award }
      else
        format.html { render :new }
        format.json { render json: @game_award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_awards/1
  # PATCH/PUT /game_awards/1.json
  def update
    respond_to do |format|
      if @game_award.update(game_award_params)
        format.html { redirect_to @game_award, notice: 'Game award was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_award }
      else
        format.html { render :edit }
        format.json { render json: @game_award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_awards/1
  # DELETE /game_awards/1.json
  def destroy
    @game_award.destroy
    respond_to do |format|
      format.html { redirect_to game_awards_url, notice: 'Game award was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_award
      @game_award = GameAward.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_award_params
      params.require(:game_award).permit(:game_round_id, :position, :name, :prize_count, :prize_name)
    end
end
