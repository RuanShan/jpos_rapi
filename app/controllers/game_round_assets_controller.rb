class GameRoundAssetsController < ApplicationController
  before_action :set_game_round_asset, only: [:show, :edit, :update, :destroy]

  # GET /game_round_assets
  # GET /game_round_assets.json
  def index
    @game_round_assets = GameRoundAsset.all
  end

  # GET /game_round_assets/1
  # GET /game_round_assets/1.json
  def show
  end

  # GET /game_round_assets/new
  def new
    @game_round_asset = GameRoundAsset.new
  end

  # GET /game_round_assets/1/edit
  def edit
  end

  # POST /game_round_assets
  # POST /game_round_assets.json
  def create
    @game_round_asset = GameRoundAsset.new(game_round_asset_params)

    respond_to do |format|
      if @game_round_asset.save
        format.html { redirect_to @game_round_asset, notice: 'Game round asset was successfully created.' }
        format.json { render :show, status: :created, location: @game_round_asset }
      else
        format.html { render :new }
        format.json { render json: @game_round_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_round_assets/1
  # PATCH/PUT /game_round_assets/1.json
  def update
    respond_to do |format|
      if @game_round_asset.update(game_round_asset_params)
        format.html { redirect_to @game_round_asset, notice: 'Game round asset was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_round_asset }
      else
        format.html { render :edit }
        format.json { render json: @game_round_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_round_assets/1
  # DELETE /game_round_assets/1.json
  def destroy
    @game_round_asset.destroy
    respond_to do |format|
      format.html { redirect_to game_round_assets_url, notice: 'Game round asset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_round_asset
      @game_round_asset = GameRoundAsset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_round_asset_params
      params.require(:game_round_asset).permit(:game_round_id, :game_player_id)
    end
end
