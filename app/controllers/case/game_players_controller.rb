module Case
  class GamePlayersController < BaseController
    before_action :set_game_player, only: [:show, :edit, :update]


    # GET /game_players/1
    # GET /game_players/1.json
    def show
    end

    # GET /game_players/new
    def new
      @game_player = GamePlayer.new
    end

    # GET /game_players/1/edit
    def edit
    end

    # POST /game_players
    # POST /game_players.json
    def create
      #每个玩家每个游戏，每个店铺，只需注册一次。
      @game_player = GamePlayer.find_or_initialize_by(game_player_params.slice(:openid, :store_id, :game_round_id))
      @game_player.assign_attributes( game_player_params )
      if params[:base64_image].present?
        @game_player.wedding_photo||= @game_player.build_wedding_photo(  )
        @game_player.wedding_photo.base64_image = params[:base64_image]
      end
      respond_to do |format|
        if @game_player.save
          format.html { redirect_to @game_player, notice: 'Game lucky user was successfully created.' }
          format.json { render :show, status: :created, location: @game_player }
        else
          format.html { render :new }
          format.json { render json: @game_player.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /game_players/1
    # PATCH/PUT /game_players/1.json
    def update
      respond_to do |format|
        if @game_player.update(game_player_params)
          format.html { redirect_to case_game_round_path(@game_player.game_round), notice: '玩家信息更新成功.' }
          format.json { render :show, status: :ok, location: @game_player }
        else
          format.html { render :edit }
          format.json { render json: @game_player.errors, status: :unprocessable_entity }
        end
      end
    end



    private
      # Use callbacks to share common setup or constraints between actions.
      def set_game_player
        @game_player = GamePlayer.find( params[:id] )
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def game_player_params
        params.require(:game_player).permit( :birth, :score, :realname, :cellphone, :openid,:store_id, :game_round_id, :memo,  wedding_photo_attributes: [:type, :base64_image]  )
      end
  end
end
