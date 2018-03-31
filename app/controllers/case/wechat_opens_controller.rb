module Case
  class WechatOpensController < BaseController
    skip_before_action  :verify_authenticity_token
    before_action :decrypt_string, only: [:notify, :ticket]

    def index

    end

    def bind
      @wx_mp_user
    	## if @wx_mp_user && !@wx_mp_user.cancel?
      ##    return redirect_to platforms_path, alert: '您已经绑定过公众号'
      ##  end

      redirect_uri = URI.encode_www_form_component case_wechat_auth_url
      redirect_to "https://mp.weixin.qq.com/cgi-bin/componentloginpage?component_appid=#{WechatOpen.component_appid}&pre_auth_code=#{WechatOpen.pre_auth_code}&redirect_uri=#{redirect_uri}?wx_mp_user_id=#{@wx_mp_user.id}"
    end

    def auth
      if params[:auth_code].present?
        auth_code = params[:auth_code]
        @wx_mp_user = WxMpUser.find params[:wx_mp_user_id]
        auth_hash = WechatOpen.fetch_api_auth(params[:auth_code] )

        wx_mp_user = nil
        WxMpUser.transaction do
          appid, access_token, expires_in, refresh_token, func_info = auth_hash.values_at('authorizer_appid', 'authorizer_access_token', 'expires_in', 'authorizer_refresh_token', 'func_info')
          wx_mp_user = @wx_mp_user
          wx_mp_user.update_attributes(app_id: appid, access_token: access_token, refresh_token: refresh_token, expires_in: expires_in.to_i.seconds.from_now, func_info: func_info, auth_code: auth_code, bind_type: WxMpUser.bind_types[:plugin], binds_count: wx_mp_user.binds_count.to_i + 1, status: WxMpUser.statuses[:active])
          wx_mp_user.fetch_auth_info
        end

        if wx_mp_user.blank?
          @error = '绑定失败！'
        end
      else
        @error = '绑定失败！'
      end
      redirect_to case_wechat_opens_path, notice: @error || '绑定成功'
    end

    private
      def check_signature
        checked = check_signatrue?(Settings.wx_plugin.token, params[:signature], params[:timestamp], params[:nonce])
        render text: '签名验证失败' and return false unless checked
      end

      def check_signatrue?(token, signature, timestamp, nonce)
        return false if token.blank?

        signature == Digest::SHA1.hexdigest([token.to_s, timestamp.to_s, nonce.to_s].sort.join)
      end

      def decrypt_string
        aes_key           = Base64.decode64(Settings.wx_plugin.encoding_aes_key + '=')
        aes_encoded_msg   = Base64.decode64(params[:xml][:Encrypt])

        de_cipher         = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
        de_cipher.decrypt
        de_cipher.padding = 7
        de_cipher.key     = aes_key
        de_cipher.iv      = aes_key[0, 16]
        str               = de_cipher.update(aes_encoded_msg).strip

        last_right_angle_index = str.rindex('>')
        hash = HashWithIndifferentAccess.new(Hash.from_xml(str[20..last_right_angle_index]))

        @xml = hash['xml']
      end
  end
end
