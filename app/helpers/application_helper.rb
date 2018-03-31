# :reek:UtilityFunction
module ApplicationHelper

  def wechat_config_params(config_options = {})
    #if controller.request.original_url =~ /design.getstore.cn/
    #  config_options[:debug] = true
    #end
    account = config_options[:account]
    # copy from module Wechat::Helpers
    # not default account
    config = Wechat.config()
    domain_name = config.trusted_domain_fullname
    api = Wechat.api
    appid = config.corpid || config.appid

    page_url = if domain_name
                 "#{domain_name}#{controller.request.original_fullpath}"
               else
                 controller.request.original_url
               end
    page_url = controller.request.original_url
    js_hash = api.jsapi_ticket.signature(page_url)

    config_params = {
      debug: !!config_options[:debug],
      appid: appid,
      timestamp: js_hash[:timestamp],
      nonce_str: js_hash[:noncestr],
      signature: js_hash[:signature],
      js_api_list: config_options[:api]||[]
    }

  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def spinner_tag(id)
    # Assuming spinner image is called "spinner.gif"
    image_tag('spinner.gif', id: id, alt: t('label.loading'), style: 'display:none')
  end

  def spaces(num)
    ('&nbsp;' * num).html_safe # rubocop:disable Rails/OutputSafety
  end

  # url_params { controller: 'my/deposits'}
  def build_nav_link( text, url_params={} )

    link_to url_for(url_params ), class: ( current_page?(url_params) ? "nav-link active" : "nav-link" )do
       text
    end
  end

  def message_verifier
    @verifier ||= ActiveSupport::MessageVerifier.new( Rails.application.secrets.secret_key_base )
  end

end
