class Game < ApplicationRecord


  # qiandao, bahe, shuqian
  enum code: { unknown: 0, check_in: 10, tug: 20, counting: 30, runlin_car_game: 1001, runlin_dumpling: 1002, yuhe_photo_contest: 1010, yhzy_smp: 1020, yhzy_ido: 1021, yhzy_jhj: 1022 , jlcj_kuaidi: 3001  }, _prefix: :code
  enum wx_oauth2_scope: { snsapi_userinfo: 0, snsapi_base: 1 }
  has_many :game_rounds

  #GAME_FOR_BIG_SCENE = [ codes[:check_in], codes[:counting]]

  #根据用户活动数据计算用户分数
  def evaluate_score( game_result )
    score = 0
    trail = game_result.trail
    if code_runlin_car_game?
      # 0 闪电，加分
      # 1，2，3 路障，减血
      # 4 车标，弹出1-5代车系信息
      # 5 车系，7，7.5 改变车的图片为相应车系
      if trail.is_a? Hash
        # "trail"=>{"0"=>["1", "0", "1510672618578"], "1"=>["1", "2", "1510672620198"], "2"=>["1", "1", "1510672621758"],
        #   "3"=>["0", "1", "1510672623498"], "4"=>["0", "1", "1510672624998"], "5"=>["1", "3", "1510672627758"],
        #   "6"=>["1", "3", "1510672629197"]}}, "code"=>"2cab6074f554c390dda607c10f5
        last_time = nil
        trail.keys.map(&:to_i).sort.each {|key|
          val = trail[key.to_s]
          #是否撞击，撞击对象，撞击时间
          hit, item, timestamp = val[0], val[1], val[2]
          timestamp = Time.at( val[2].to_f/1000 )
          if hit == '0'
            #躲过路障,其他也加分，历史问题
            if item != '0' #item== '1' || item== '2' || item== '3'
              score+=10
            end
          else
            if  item== '0'
              score+=20
            elsif item == '4'
              score+=10
            end
          end
          #Rails.logger.debug "key=#{key}, val=#{val}, score=#{score}"
          # 10秒内一定会有障碍物出现，如果>10秒，说明数据有问题
          unless (last_time.nil? || ( timestamp > last_time && timestamp-last_time<10 ))
            score = 0; break;
          end

        }

      end
    end
    score
  end

  def support_big_scene?
    ['check_in','counting'].include? code
  end
end
