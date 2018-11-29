class MpMsgJob < ApplicationJob
  TemplateTypeEnum = Struct.new( "MpTemplateType", "new_order_created", "deposit_success")['new_order_created', "deposit_success"]
  queue_as :message


  def perform( order, template_type )
      Rails.logger.error " send mp message  #{order.number}"

      template_yaml_path = File.join( Rails.root, 'config', 'wechat_template.yml')

      template = YAML.load(File.read(template_yaml_path))

      if template_type == TemplateTypeEnum.new_order_created
        template_name = "#{Rails.env}_#{template_type}"
        send_new_order_created_message( order, template[template_name])
      elsif template_type == TemplateTypeEnum.deposit_success
        send_deposit_success_message( order, template[template_name])
      end

  end


  # params -
  #   first:{  value: "订单生成通知" }
  #   keyword1:{ value: "2014年7月21日 18:36",  color: "#CCCCCC"}
  #   keyword2:{ value: "苹果",  color: "#CCCCCC"}
  #   keyword3:{ value: "007",   color: "#CCCCCC"}
  #   remark:{ value: ""}
  # 尊敬的用户您好！您的订单已经提交成功！
  # 会员名：XX先生/小姐
  # 订单号：20160825163959-637
  # 支付金额：20元
  # 支付时间：2016年8月25日
  # 支付类型：微信支付
  # 感谢您的使用，如有疑问，可联系我们的客服人员。
  def send_new_order_created_message( order, template )
    wx_follower = order.customer.wx_follower
    if wx_follower
      template['url'] = "#{Rails.configuration.application['wx_url']}/mp/orders/#{order.id}"
      template['data']['keyword1']['value'] = order.customer.username
      template['data']['keyword2']['value'] = order.number
      template['data']['keyword3']['value'] = order.total
      template['data']['keyword4']['value'] = order.display_created_at
      template['data']['keyword5']['value'] = order.display_payment_method_names
      Wechat.api.template_message_send Wechat::Message.to(wx_follower.openid).template( template )
    end

  end

  # 杨小姐，充值成功。
  # 本次充值金额：1500
  # 充值后余额：1850
  # 充值门店：武林广场店
  # 武林广场店(0512-88888888)感谢您的一贯支持。
  def send_deposit_success_message( order, template )
    wx_follower = order.customer.wx_follower
    if wx_follower
      template['url'] = "#{Rails.configuration.application['wx_url']}/mp/order/#{order.id}"
      template['data']['keyword1']['value'] = order.total
      template['data']['keyword2']['value'] = order.card_transactions.sum(&:amount_remaining)
      template['data']['keyword3']['value'] = order.store_name
      Wechat.api.template_message_send Wechat::Message.to(wx_follower.openid).template( template )
    end

  end
end
