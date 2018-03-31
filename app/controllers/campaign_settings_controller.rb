class GameSettingsController < ApplicationController
  before_action :set_game_setting, only: [:show, :edit, :update, :destroy]

  # GET /game_settings
  # GET /game_settings.json
  def index
    @game_settings = GameSetting.all
  end

  # GET /game_settings/1
  # GET /game_settings/1.json
  def show
  end

  # GET /game_settings/new
  def new
    @game_setting = GameSetting.new
  end

  # GET /game_settings/1/edit
  def edit
  end

  # POST /game_settings
  # POST /game_settings.json
  def create
    @game_setting = GameSetting.new(game_setting_params)

    respond_to do |format|
      if @game_setting.save
        format.html { redirect_to @game_setting, notice: 'Game setting was successfully created.' }
        format.json { render :show, status: :created, location: @game_setting }
      else
        format.html { render :new }
        format.json { render json: @game_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_settings/1
  # PATCH/PUT /game_settings/1.json
  def update
    respond_to do |format|
      if @game_setting.update(game_setting_params)
        format.html { redirect_to @game_setting, notice: 'Game setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_setting }
      else
        format.html { render :edit }
        format.json { render json: @game_setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_settings/1
  # DELETE /game_settings/1.json
  def destroy
    @game_setting.destroy
    respond_to do |format|
      format.html { redirect_to game_settings_url, notice: 'Game setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_setting
      @game_setting = GameSetting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_setting_params
      params.require(:game_setting).permit(:wx_name, :game_id, :wx_status)
    end
end
