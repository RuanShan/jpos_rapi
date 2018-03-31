# weixin help
# https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1453779503&token=dbe25b115ff303090e4aa835aba67dbb551cce12&lang=zh_CN
module WechatOpen

    VERIFY_TICKET_KEY          = "#{Rails.env}:wechatmore:wx_plugin:component_verify_ticket"
    COMPONENT_ACCESS_TOKEN_KEY = "#{Rails.env}:wechatmore:wx_plugin:component_access_token"
    PRE_AUTH_CODE_KEY          = "#{Rails.env}:wechatmore:wx_plugin:pre_auth_code"

    class << self

      def component_verify_ticket
        WechatOpen.cache.read(VERIFY_TICKET_KEY)
      end

      # Result Example Data: {"component_access_token":"61W3mEpU66027wgNZ_MhGHNQDHnFATkDa9-2llqrMBjUwxRSNPbVsMmyD-yq8wZETSoE5NQgecigDrSHkPtIYA","expires_in":7200}
      def fetch_component_access_token
        post_body = {
          component_appid:         component_appid,
          component_appsecret:     component_appsecret,
          component_verify_ticket: self.component_verify_ticket
        }.to_json
        result = HTTParty.post('https://api.weixin.qq.com/cgi-bin/component/api_component_token', body: post_body)
        return if result['component_access_token'].blank?
        token_hash = { component_access_token:  result['component_access_token'], expired_at: (result['expires_in'].seconds.from_now.to_i - 5) }
        WechatOpen.cache.write COMPONENT_ACCESS_TOKEN_KEY, token_hash.to_json
        result['component_access_token']
      end

      def component_access_token
        expired_at = 0
        json = WechatOpen.cache.read(COMPONENT_ACCESS_TOKEN_KEY )
        if json.present?
          token_hash = JSON.parse(json)
          expired_at= token_hash.fetch('expired_at').to_i
          component_token = token_hash.fetch('component_access_token')
        end

        if Time.now.to_i > expired_at
          fetch_component_access_token
        else
          component_token
        end
      end

      # Result Example Data: {"pre_auth_code":"Cx_Dk6qiBE0Dmx4EmlT3oRfArPvwSQ-oa3NL_fwHM7VI08r52wazoZX2Rhpz1dEw","expires_in":1200}
      def fetch_pre_auth_code
        url = "https://api.weixin.qq.com/cgi-bin/component/api_create_preauthcode?component_access_token=#{component_access_token}"
        post_body = {component_appid: component_appid}.to_json
        result = HTTParty.post(url, body: post_body)
        code = result['pre_auth_code']
        return if code.blank?
        token_hash = { pre_auth_code: code, expired_at: (result['expires_in'].seconds.from_now.to_i - 5) }
        WechatOpen.cache.write PRE_AUTH_CODE_KEY, token_hash.to_json

        code
      end

      def pre_auth_code
        # pre_auth_code, expired_at = WechatOpen.cache.hmget(PRE_AUTH_CODE_KEY, :value, :expired_at)
        #if Time.now.to_i > expired_at.to_i
          fetch_pre_auth_code
        #else
          #pre_auth_code
        #end
      end


      def fetch_api_auth(auth_code)

        url = 'https://api.weixin.qq.com/cgi-bin/component/api_query_auth?component_access_token=' + component_access_token
        post_body = { component_appid: component_appid, authorization_code: auth_code }.to_json
        result = HTTParty.post(url, body: post_body)
        auth_info = result['authorization_info']
        auth_info

      end

      def aes_key
        Base64.decode64 "#{Rails.application.secrets.wx_open[:base64_aes_key]}="
      end

      def encoding_aes_key
        Rails.application.secrets.wx_open[:encoding_aes_key]
      end

      def component_appid
        Rails.application.secrets.wx_open[:component_appid]
      end

      def component_appsecret
        Rails.application.secrets.wx_open[:component_appsecret]
      end
      #公众号消息校验Token
      def token
        Rails.application.secrets.wx_open[:token]
      end

    end

# component_access_token = Binding.component_access_token
# pre_auth_code = Binding.pre_auth_code
# app_id       = 'wx818e511f332984b9'
# redirect_uri = URI.encode_www_form_component('http://plugin.weixin.wechatmore.com/xxxxx')
# scope        = 'snsapi_base'
# url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{app_id}&redirect_uri=#{redirect_uri}&response_type=code&scope=#{scope}&state=my_state&component_appid=#{component_appid}#wechat_redirect"
# "http://plugin.weixin.wechatmore.com/xxxxx?auth_code=EM_wJHVNyj6QsPige9KvOdpBQD8imrG6ZsFfs4cd5FcjOlC8gdXhQQrKwoWGUALA&expires_in=600"
end
