#游戏结束后，把游戏缓存中的数据存回到数据库中，再清除缓存数据。
class ClearGameCacheJob < ApplicationJob
  queue_as :default


  #game_times, 第几次游戏
  def perform(game_round_id, game_times)
    game_round = GameRound.where( id: game_round_id ).first
    # Do something later
    if game_round.present?
      PlayerCacheService.complete!( game_round, game_times)
    else
      Rails.logger.error " Can not find game_round=#{game_round_id}"
    end

  end
end
