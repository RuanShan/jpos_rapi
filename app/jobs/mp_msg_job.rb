class MpMsgJob < ApplicationJob
  TemplateTypeEnum = Struct.new( "MpTemplateType", "new_order_created")['new_order_created']
  queue_as :message


  def perform( order, template_type )
      Rails.logger.error " send mp message  #{order.number}"

      template_yaml_path = File.join( Rails.root, 'config', 'wechat_template.yml')

      template = YAML.load(File.read(template_yaml_path))

      if template_type == TemplateTypeEnum.new_order_created
        send_new_order_created_message( order, template[template_type])
      end

  end


  # params -
  #   first:{  value: "订单生成通知" }
  #   keyword1:{ value: "2014年7月21日 18:36",  color: "#CCCCCC"}
  #   keyword2:{ value: "苹果",  color: "#CCCCCC"}
  #   keyword3:{ value: "007",   color: "#CCCCCC"}
  #   remark:{ value: ""}

  def send_new_order_created_message( order, template )
    wx_follower = order.customer.wx_follower
    if wx_follower
      template['url'] = "#{Rails.configuration.application['wx_url']}/mp/order/#{order.id}"
      template['data']['keyword1']['value'] = order.display_created_at
      template['data']['keyword2']['value'] = order.number
      template['data']['keyword3']['value'] = order.number
      Wechat.api.template_message_send Wechat::Message.to(wx_follower.openid).template( template )
    end

  end

end
