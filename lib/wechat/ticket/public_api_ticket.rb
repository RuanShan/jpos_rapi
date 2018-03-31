require 'wechat/ticket/jsapi_base'

module Wechat
  module Ticket
    class PublicApiTicket < JsapiBase
      def refresh
        data = client.get('ticket/getticket', params: { access_token: access_token.token, type: 'wx_card' })
        #data['oauth2_state'] = SecureRandom.hex(16)
        write_ticket_to_store(data)
        read_ticket_from_store
      end

      #cardExt本身是一个JSON字符串，是商户为该张卡券分配的唯一性信息，包含以下字段：
      #  params = {
      #    card_id: card_id,
      #    noncestr: noncestr,
      #    timestamp: timestamp,
      #    api_ticket: ticket,
      #    signature: signature
      #  }

      def card_ext(card_id='', code=nil, openid=nil)
        timestamp = Time.now.to_i
        nonce_str = SecureRandom.hex(16)
        apiticket = ticket
        sort_params = [ apiticket, timestamp.to_s, card_id.to_s, code.to_s, openid.to_s, nonce_str ].sort.join
        signature = Digest::SHA1.hexdigest(sort_params)
        {
          code: code,
          openid: openid,
          timestamp: timestamp,
          nonce_str: nonce_str,
          signature: signature
        }
      end

      #.将 api_ticket、timestamp、card_id、code、openid、nonce_str的value值进行字符串的字典序排序。
      #  params = {
      #    openid: openid,
      #    card_id: card_id,
      #    noncestr: noncestr,
      #    timestamp: timestamp,
      #    api_ticket: ticket,
      #    signature: signature
      #  }
      def signature(openid, card_id)
        params = {
          openid: openid,
          card_id: card_id,
          noncestr: SecureRandom.base64(16),
          timestamp: Time.now.to_i,
          api_ticket: ticket
        }
        pairs = params.keys.sort.map do |key|
          "#{key}=#{params[key]}"
        end
        result = Digest::SHA1.hexdigest pairs.join('&')
        params.merge(signature: result)
      end

      protected

      def read_ticket_from_store
        Rails.logger.debug "jsapi_ticket_file=#{jsapi_ticket_file}"
        td = read_ticket
        @ticket_life_in_seconds = td.fetch('ticket_expires_in').to_i
        @got_ticket_at = td.fetch('got_ticket_at').to_i
        @access_ticket = td.fetch('ticket') # return access_ticket same time
      rescue JSON::ParserError, Errno::ENOENT, KeyError, TypeError
        refresh
      end

    end
  end
end
