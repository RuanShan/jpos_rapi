#存储游戏实时分数到缓存中
class PlayerCacheService

  def self.reset( game_round )
    key = build_key( game_round )
    $redis.del( key )
  end

  def self.init( game_round )
    key = build_key( game_round )
    players = game_round.current_players
    players.each{|player|
      $redis.zadd( key, player.score, player.id )
    }
  end

  def self.update_score( game_round, game_player, new_score)

    key = build_key( game_round )
    # struct zset
    # key = 'game_round_id', value ='game_player_id', score='game_player.score'
    #key =
    $redis.zadd( key, new_score, game_player.id )
  end

  def self.get_ranked_players( game_round )
    game_players = game_round.current_players
    scores = rank( game_round)
    game_players.each{|player|
        scores.each_with_index{|id_score, i|
          id,score = id_score #  [1,2]=> 1,2
          Rails.logger.debug "id=#{id} score=#{score} i=#{i} "
          if player.id == id
          #player should always exists, except debug
            player.rank = i+1
            player.score = score
            break
          end
        }
    }

    ranked_players = game_players.sort{|gp1,gp2| gp2.score <=> gp1.score }
  end


  def self.player_info( game_round, game_player)
    key = build_key( game_round )
    scores = rank( game_round )
    player_rank = scores.index{|id,score| id == game_player.id }
    Rails.logger.debug " cache scores=#{scores}, game_player.id=#{game_player.id},  player_rank=#{player_rank}"
    if player_rank
      #player_rank start from 0
      game_player.rank = player_rank+1
      game_player.score = scores[player_rank][1]
    end
    game_player
  end


  def self.complete!( game_round, game_times)
    scores = rank( game_round)
    #score_hash = Hash[ scores ]# [["99", 10.0]] => {'99'=>10}
    players = game_round.current_players.order( :id ).to_a
    scores.each_with_index{|id_score, i|
      id, score = id_score #  [1,2]=> 1,2
      player = players.select{|player| player.id == id}.first
      Rails.logger.debug " id=#{id} score=#{score},players=#{players.inspect} player=#{player.inspect}"
      player.update rank: i+1, score:  score, cache_free_at: DateTime.current
    }
  end


  # return [ {id: n, score: m}]
  def self.rank( game_round)
    #如果游戏已结束，并清空缓存，那么就无法找到排名
    key = build_key( game_round )
    #[["99", 10.0]]
    scores = $redis.zrevrange( key, 0, -1, with_scores: true ) || []
    #res.map{ |res| { id: res[0].to_i, score: res[1] } }
    scores.map{|id,score| [id.to_i, score.to_i] } #[["99", 10.0]] => [ [99, 10]]
  end

  def self.build_key( game_round )
    key = "game_round_#{game_round.id}_#{game_round.play_times}"
  end

end
