class Api::V1::GamePlayersController < Api::V1::BaseController
  before_action :set_game_player, only: [:update, :show, :score]

  # curl -i -X GET http://localhost:3000/api/v1/game_rounds/1/players?per_page=3
  #{ "paginate_meta":{"current_page":1,"next_page":2,"prev_page":null,"total_pages":2,"total_count":6},
  #  "game_players":[{"id":1,"avatar":"http://wx.qlogo.cn/mmopen/Q3auHgzwzM61FPBtkpLIFAjB97N4shINzXfGYNyMbs5gQJ0SvEqQw2Pln8WGjHNRfBxwfs1SlicSxkjJeBc4AGnGvDEE8eXk2KTLKwZWHZE4/0","nickname":"try","position":null},{"id":2,"avatar":"http://wx.qlogo.cn/mmopen/Q3auHgzwzM61FPBtkpLIFAjB97N4shINzXfGYNyMbs5gQJ0SvEqQw2Pln8WGjHNRfBxwfs1SlicSxkjJeBc4AGnGvDEE8eXk2KTLKwZWHZE4/0","nickname":"try","position":1},{"id":3,"avatar":"http://wx.qlogo.cn/mmopen/Q3auHgzwzM61FPBtkpLIFAjB97N4shINzXfGYNyMbs5gQJ0SvEqQw2Pln8WGjHNRfBxwfs1SlicSxkjJeBc4AGnGvDEE8eXk2KTLKwZWHZE4/0","nickname":"try","position":1}]
  #}
  # get game_players by game_round_id
  def index
    query = @game_round.game_players.includes( :game_award)
    if params[:q_term].present?
      query = query.name_like params[:q_term]
    end
    @game_players = paginate( query )
  end
  # curl -i http://localhost:3000/api/v1/game_players/1
  def show
  end

  # curl -i -X GET http://localhost:3000/api/v1/game_rounds/1/game_players/next_by_position.json?position=3
  # {"game_player":{"id":null,"avatar":"","nickname":"","position":null}}
  # params : position
  def next_by_position
    @position = params[:position].to_i
    @game_player = @game_round.game_players.where( ["position>=?", @position]).first
  end

  #$ curl -i -X GET http://localhost:3000/api/v1/game_rounds/1/game_players/noaward.json?per_page=3
  def noaward

    game_player_ids = @game_round.game_award_players.pluck(:game_player_id)
    @game_players = @game_round.game_players.where.not( id: game_player_ids)
  end

  def awarded
    award_time = @game_round.award_times
    game_player_ids = @game_round.game_award_players.where(award_time: award_time).pluck(:game_player_id)
    @game_players = @game_round.game_players.includes( game_award_player: :game_award).where( id: game_player_ids).order( "game_awards.position, game_award_players.created_at" )
  end


  # 玩家更新自己的成绩
  # curl -i -X PUT -d "game_player[realname]=可爱多&game_player[cellphone]=13312345678" http://localhost:3000/api/v1/game_players/31
  # {"game_player":{"id":42,"avatar":"http://wx.qlogo.cn/mmopen/VX7U0xDSUxgL7k7xGcKNmUjRTaibhnbMXGwbiaB0HuBicvH3HCuhAicf1k5wz7t9b9QBFicATSdqQu13WtDEVmmfM3ibAiatEUEDsmk/0","nickname":"getstore.cn","position":1}}
  def update
    if  @game_player.update(game_player_params)
      render :show, status: :ok, location: @game_player
    else
      invalid_resource!( @game_player )
    end
  end

  def score
    if  @game_player.update(game_player_score_params)
      #取得最新排名和排名%
      @game_player.game_awards.each{|game_award|
        if game_award.is_a? CardPrize
        end
      }
      render :score, status: :ok, location: @game_player
    else
      invalid_resource!( @game_player )
    end
  end

  private
  # 这里不应该加密，API主要是为第三方服务的，这里还是应该使用TOKEN方式调用
  # 为了安全，使用 ActiveSupport::MessageVerifier
  # params[gpid] : encrypted game_player_id
  def set_game_player
    @game_player = GamePlayer.find(params[:id])
    @game_round = @game_player.game_round
  end

  def game_player_params
    params.require(:game_player).permit(:game_round_id, :realname, :cellphone, :score)
  end

  def game_player_score_params
    params.require(:game_player).permit(:score)
  end
end
