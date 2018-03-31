require 'csv'
module Case
  class GameRoundsController < BaseController
    before_action :set_game_round, only: [:show, :edit, :update, :destroy, :players, :player_results]
    # GET /game_rounds
    # GET /game_rounds.json
    def index
      @game_rounds = current_user.game_rounds
    end

    def by_code
      game_code = params[:code]
      @game = Game.find_by_code( game_code ) || Game.first

      @game_rounds = @campaign.game_rounds.where game: @game
    end

    # GET /game_rounds/1
    # GET /game_rounds/1.json
    def show
      @game = @game_round.game
      @q = GamePlayer.where(game_round: @game_round).ransack(params[:q])
      Rails.logger.debug " @q #{@q.inspect}"
      @game_players  = @q.result.page( params[:page])
    end

    # GET /game_rounds/new
    def new
      @game = Game.find_by_code(params[:code]) || Game.first
      @game_round = @game.game_rounds.build
    end

    # GET /game_rounds/1/edit
    def edit
      @campaign = @game_round.campaign
    end

    # POST /game_rounds
    # POST /game_rounds.json
    def create
      @game_round = GameRound.new(game_round_params)

      respond_to do |format|
        @game_round.campaign = @campaign
        @game_round.creator = current_user
        if @game_round.save
          format.html {
            redirect_to( {action: :index}, notice: 'Game instance was successfully created.')
          }
          format.json { render :show, status: :created, location: @game_round }
        else
          format.html { render :new }
          format.json { render json: @game_round.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /game_rounds/1
    # PATCH/PUT /game_rounds/1.json
    def update
      respond_to do |format|
        if @game_round.update(game_round_params)
          format.html { redirect_to case_game_rounds_path , notice: 'Game instance was successfully updated.' }
          format.json { render :show, status: :ok, location: @game_round }
        else
          format.html { render :edit }
          format.json { render json: @game_round.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /game_rounds/1
    # DELETE /game_rounds/1.json
    def destroy
      @campaign = @game_round.campaign
      @game =  @game_round.game
      @game_round.destroy
      respond_to do |format|
        format.html {
          redirect_to by_code_case_campaign_game_rounds_path( @campaign, code:@game.code ),
            notice: 'Game instance was successfully destroyed.'
        }
        format.json { head :no_content }
      end
    end

    #https://ruby-china.org/topics/2952
    #导出game_players 数据到CSV文件
    def players

      @q = GamePlayer.where(game_round: @game_round).ransack(params[:q])
      @game_players  = @q.result

      respond_to do |format|
        format.json { render json: @game_players }

        format.csv do
          render_csv_header 'Game_Player_Report'
          csv_res = CSV.generate do |csv|
            csv << GamePlayer.new.attributes.keys
            @game_players.each do |player|
                 csv << player.attributes.values
            end
          end
          send_data "\xEF\xBB\xBF"<<csv_res  #.force_encoding("ASCII-8BIT")
        end
      end
    end


    def player_results
      @game = @game_round.game
      @q = GameResult.where(game_round: @game_round).order(created_at: :desc).ransack(params[:q])
      #Rails.logger.debug " @q #{@q.inspect}"
      if  request.format == Mime[:csv]
        @game_results  = @q.result
      else
        @game_results  = @q.result.page( params[:page])
      end
      respond_to do |format|
        format.html { render :player_results }
        format.json { render json: @game_results }

        format.csv do
          render_csv_header 'Game_Result_Report'
          fields = ['id','delivery_room','realname','cellphone','delivery_cellphone', 'delivery_sms_at', 'display_delivery_sms', 'display_delivery_time_option',  'memo', 'delivery_sms']
          csv_res = CSV.generate do |csv|
            csv << ['ID', '寝室','收件人姓名','收件人电话','联系电话','短信时间','短信筛选','配送时间','备注','取件短信']
            @game_results.each do |player|
               attrs = fields.map{|field| player.send field}
               csv << attrs
            end
          end
          send_data "\xEF\xBB\xBF"<<csv_res  #.force_encoding("ASCII-8BIT")
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_game_round
        @game_round = GameRound.find(params[:id])
        @campaign = @game_round.campaign
      end

      def set_campaign
        @campaign = Campaign.find(params[:campaign_id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def game_round_params
        permitted_params = params.require(:game_round).permit(:game_id, :name,:code, :desc, :open_at, :close_at, :start_at, :end_at, :preferences, :contact_required, :awards, \
          :display_players, :gear, :duration, \
          game_awards_attributes:  [ :id,  :name, :position, :prize_count, :prize_name, :_destroy  ],
          logo_attributes: [:id, :attachment, :name, :alt, :desc],
          mobile_background_attributes: [:id, :attachment, :name, :alt, :desc],
          screen_background_attributes: [:id, :attachment, :name, :alt, :desc]
        )
         #:award_counts_0, :award_counts_1, :award_counts_2, :award_counts_3, :award_counts_4
        if permitted_params.key? :awards
          permitted_params[:awards] = permitted_params[:awards].to_i
        end

        #if permitted_params.key? :award_counts_0
        #  permitted_params[:award_counts] = []
        #  5.times{|i|
        #    key = "award_counts_#{i}"
        #    permitted_params[:award_counts][i] = permitted_params.delete( key ).to_i
        #  }
        #end
        permitted_params

      end
  end

end
