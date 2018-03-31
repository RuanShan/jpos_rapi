#微信开放平台接口
class Api::V1::WechatOpensController < ApplicationController
    skip_before_action  :verify_authenticity_token
    before_action :decrypt_string, only: [:notify]

    # 存储 ComponentVerifyTicket
    # 授权事件接收URL
    # 用于接收取消授权通知、授权成功通知、授权更新通知，也用于接收ticket，ticket是验证平台方的重要凭据。
    def notify
      if @xml['ComponentVerifyTicket'].present?
        WechatOpen.cache.write(WechatOpen::VERIFY_TICKET_KEY, @xml['ComponentVerifyTicket'])
        #检查是否需要刷新component_access_token
        #WechatOpen.component_access_token
      elsif @xml['InfoType'].eql?('unauthorized') && @xml['AuthorizerAppid'].present?
        mp_user = WxMpUser.where(app_id: @xml['AuthorizerAppid']).first
        if mp_user
          if mp_user.code.present? & mp_user.token.present?
            mp_user.update_attributes(bind_type: 1)
          else
            mp_user.update_attributes(bind_type: -1)
          end
        end
      end
      render plain: 'success'
    end


    private


      def check_signature
        checked = check_signatrue?( WechatOpen.token, params[:signature], params[:timestamp], params[:nonce])
        render plain: '签名验证失败' and return false unless checked
      end

      def check_signatrue?(token, signature, timestamp, nonce)
        return false if token.blank?

        signature == Digest::SHA1.hexdigest([token.to_s, timestamp.to_s, nonce.to_s].sort.join)
      end

      def decrypt_string
        aes_key           = Base64.decode64(WechatOpen.encoding_aes_key + '=')
        aes_encoded_msg   = Base64.decode64(request_encrypt_content)

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

      def request_encrypt_content
        request_content['xml']['Encrypt']
      end

      def request_content
        params[:xml].nil? ? Hash.from_xml(request.raw_post) : { 'xml' => params[:xml] }
      end
end
