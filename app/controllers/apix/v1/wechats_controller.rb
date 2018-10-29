module Api
  module V1
    class WechatsController < BaseController

      #Rails.logger.info "debug_echo#{ ENV['JPOS_WECHAT_APPID'] }"

      # For details on the DSL available within this file, see https://github.com/Eric-Guo/wechat#rails-responder-controller-dsl
      wechat_responder

      on :text do |request, content|
          request.reply.text "echo: #{content}" # Just echo
      end

      # When receive 'help', will trigger this responder
      on :text, with: /^gr(\d+)/i do |request, id|
        game_round = GameRound.find( id )
        Rails.logger.debug "request[:FromUserName]=#{request[:FromUserName]}"
        user = wechat.user(request[:FromUserName])#调用 api 获得发送者的nickname
        request_parameters = { openid: request[:FromUserName], nickname: user['nickname'], headimgurl: user['headimgurl']}
        game_round_json ={}
        game_round_json['check_in_url'] = check_in_game_round_url(game_round, request_parameters)
        request.reply.text game_round_json['check_in_url']
      end

      # When receive 'help', will trigger this responder
      on :text, with: /^list (\w+)/i do |request, classname|
        model_names = []
        case classname
        when 'gameround'
          game_rounds = GameRound.all
          model_names = game_rounds.collect{ |game_round|
            "#{game_round.id} - #{game_round.name}"
          }
        end

        request.reply.text model_names.join(',')
      end

      on :text, with: /^show (\w+) (\d+)/i do |request, classname, id|
        #FromUserName is openid
        #nickname = wechat.user(request[:FromUserName])['nickname'] #调用 api 获得发送者的nickname
        #Rails.logger.debug " request[:FromUserName]=#{request[:FromUserName]} nickname=#{nickname}"
        request_parameters = { openid: request[:FromUserName]}
        game_round_json = nil
        case classname
          when 'gameround'
            game_round = GameRound.find( id )
            game_round_json = game_round.as_json
            game_round_json['check_in_url'] = check_in_game_round_url(game_round, request_parameters)
            game_round_json['play_url'] = play_game_round_url(game_round, request_parameters)

        end
        request.reply.text game_round_json.to_s
      end

    end
  end
end
