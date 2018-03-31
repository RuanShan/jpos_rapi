module Application::CommonHelper
  extend ActiveSupport::Concern

  included do
    self.prepend_before_action :set_view_variant
    self.helper_method :mobile?
  end

  MOBILE_USER_AGENTS = 'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' \
                     'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' \
                     'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' \
                     'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' \
                     'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'
  def mobile?
    agent_str = request.user_agent.to_s.downcase
    #return true if turbolinks_app?
    return false if agent_str =~ /ipad/
    !!(agent_str =~ Regexp.new(MOBILE_USER_AGENTS))
  end

  def wechat?
    #如果是微信浏览器返回true 否则返回false
    agent_str = request.user_agent.to_s.downcase
    #Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Mobile/9B176 MicroMessenger/4.3.2
    #Mozilla/5.0 (Linux; U; Android 2.3.6; zh-cn; GT-S5660 Build/GINGERBREAD) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1 MicroMessenger/4.5.255
    !!(agent_str =~/MicroMessenger/i)
  end

  def set_view_variant
    #request.variant = :mobile if mobile?
    #request.variant = :mobile if cookies[:BETTER_DEVELOPMENT_MOBILE] == '1'
    request.variant = :wechat if mobile?
  end

  def message_verifier
    @verifier ||= ActiveSupport::MessageVerifier.new( Rails.application.secrets.secret_key_base )
  end
end
