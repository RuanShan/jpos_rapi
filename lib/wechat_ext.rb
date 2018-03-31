require 'wechat'
require 'wechat/api'
require 'wechat/ticket/public_api_ticket'

module WechatExt

end

module Wechat
  class Api
    attr_reader :api_ticket

    def initialize(appid, secret, token_file, timeout, skip_verify_ssl, jsapi_ticket_file)
      #original
      @client = HttpClient.new(API_BASE, timeout, skip_verify_ssl)
      @access_token = Token::PublicAccessToken.new(@client, appid, secret, token_file)
      @jsapi_ticket = Ticket::PublicJsapiTicket.new(@client, @access_token, jsapi_ticket_file)

      api_ticket_file = 'tmp/wechat_api_ticket'
      @api_ticket = Ticket::PublicApiTicket.new(@client, @access_token, api_ticket_file)
    end
  end
end
