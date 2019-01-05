class SmsService
  class << self

    def sendto(phone_numbers, template_code, template_param={} )

      initialize_configuration()

      response = Aliyun::Sms.send(phone_numbers, template_code, template_param.to_json)
      response_body= JSON.parse( response.response_body )
      #ApiHistory.create( name: "send_sms_verification", url: "dysmsapi.aliyuncs.com", params: template_param, result: response_body)
      Rails.logger.debug "res= #{response_body}"
      #{"Message"=>"模板变量缺少对应参数值", "RequestId"=>"D55E55C0-C6FA-4A1D-8B06-75E70FABD5CC", "Code"=>"isv.TEMPLATE_MISSING_PARAMETERS"}

      response_body.try('[]', 'Code') == 'OK'
    end
    # params
    #    template_param: {code}
    # return
    #   {"Message"=>"模板变量缺少对应参数值", "RequestId"=>"D55E55C0-C6FA-4A1D-8B06-75E70FABD5CC", "Code"=>"isv.TEMPLATE_MISSING_PARAMETERS"}
    #   {"Message":"OK","RequestId":"2A03C2FE-AC21-4AC4-AEEF-8916958ABB46","BizId":"358101836637869652^0","Code":"OK"}"
    def send_verify_code(phone_numbers, code )

      initialize_configuration()

      template_code = Rails.configuration.application['aliyun_sms_template_code_verification']
      template_param = { code: code }
      response = Aliyun::Sms.send(phone_numbers, template_code, template_param.to_json)
      response_body= JSON.parse( response.response_body )
      #ApiHistory.create( name: "send_sms_verification", url: "dysmsapi.aliyuncs.com", params: template_param, result: response_body)
      Rails.logger.debug "res= #{response_body}"
      #{"Message"=>"模板变量缺少对应参数值", "RequestId"=>"D55E55C0-C6FA-4A1D-8B06-75E70FABD5CC", "Code"=>"isv.TEMPLATE_MISSING_PARAMETERS"}

      response_body.try('[]', 'Code') == 'OK'
    end

    # params
    #    template_param: {password}
    # return
    #   {"Message"=>"模板变量缺少对应参数值", "RequestId"=>"D55E55C0-C6FA-4A1D-8B06-75E70FABD5CC", "Code"=>"isv.TEMPLATE_MISSING_PARAMETERS"}
    #   {"Message":"OK","RequestId":"2A03C2FE-AC21-4AC4-AEEF-8916958ABB46","BizId":"358101836637869652^0","Code":"OK"}"
    def send_password(phone_numbers, password )

      initialize_configuration()

      template_code = Rails.configuration.application['aliyun_sms_template_send_password']
      template_param = { password: password }
      response = Aliyun::Sms.send(phone_numbers, template_code, template_param.to_json)
      response_body= JSON.parse( response.response_body )
      #ApiHistory.create( name: "send_sms_verification", url: "dysmsapi.aliyuncs.com", params: template_param, result: response_body)
      Rails.logger.debug "res= #{response_body}"
      #{"Message"=>"模板变量缺少对应参数值", "RequestId"=>"D55E55C0-C6FA-4A1D-8B06-75E70FABD5CC", "Code"=>"isv.TEMPLATE_MISSING_PARAMETERS"}

      response_body.try('[]', 'Code') == 'OK'
    end


    # params
    #    template_param: {password}
    # return
    #   {"Message"=>"模板变量缺少对应参数值", "RequestId"=>"D55E55C0-C6FA-4A1D-8B06-75E70FABD5CC", "Code"=>"isv.TEMPLATE_MISSING_PARAMETERS"}
    #   {"Message":"OK","RequestId":"2A03C2FE-AC21-4AC4-AEEF-8916958ABB46","BizId":"358101836637869652^0","Code":"OK"}"
    def send_order_created(phone_numbers, storename, ordernumber )

      initialize_configuration()

      template_code = Rails.configuration.application['aliyun_sms_template_order_created']
      template_param = { storename: storename, ordernumber: ordernumber }
      response = Aliyun::Sms.send(phone_numbers, template_code, template_param.to_json)
      response_body= JSON.parse( response.response_body )
      #ApiHistory.create( name: "send_sms_verification", url: "dysmsapi.aliyuncs.com", params: template_param, result: response_body)
      Rails.logger.debug "res= #{response_body}"
      #{"Message"=>"模板变量缺少对应参数值", "RequestId"=>"D55E55C0-C6FA-4A1D-8B06-75E70FABD5CC", "Code"=>"isv.TEMPLATE_MISSING_PARAMETERS"}

      response_body.try('[]', 'Code') == 'OK'
    end


    def initialize_configuration
      Aliyun::Sms.configure do |config|
        config.access_key_secret = Rails.configuration.application['aliyun_sms_access_key_secret']
        config.access_key_id =  Rails.configuration.application['aliyun_sms_access_key_id']
        config.sign_name =  Rails.configuration.application['aliyun_sms_sign_name']
      end

    end

  end

end
