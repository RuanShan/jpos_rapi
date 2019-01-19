class MpMsgJob < ApplicationJob
  TemplateTypeEnum = Struct.new( "MpTemplateType", "new_order_created", "deposit_success", "order_canceled")['new_order_created', "deposit_success", "order_canceled"]
  queue_as :message


  def perform( order, template_type )
      Rails.logger.error " send mp message  #{order.number}, #{template_type}"

      template_yaml_path = File.join( Rails.root, 'config', 'wechat_template.yml')

      template = YAML.load(File.read(template_yaml_path))

      template_name = "#{Rails.env}_#{template_type}"
      if template_type == TemplateTypeEnum.new_order_created
        send_new_order_created_message( order, template[template_name])
      elsif template_type == TemplateTypeEnum.deposit_success
        send_deposit_success_message( order, template[template_name])
      elsif template_type == TemplateTypeEnum.order_canceled
        send_order_canceled_message( order, template[template_name])
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
  # 汪永峰皮具养护中心(400-0588-222)感谢您的一贯支持。
  def send_new_order_created_message( order, template )
    wx_follower = order.customer.wx_follower
    if wx_follower
      template['url'] = "#{Rails.configuration.application['wx_url']}/mp/orders/#{order.id}"
      template['data']['keyword1']['value'] = order.customer.username
      template['data']['keyword2']['value'] = order.number
      timecard_payment =  order.payments.select do|payment|
        payment.source.try( :style_times? )
      end.first
      if timecard_payment.present?
        template['data']['keyword3']['value'] = "#{timecard_payment.card_times.to_i}次"
      else
        template['data']['keyword3']['value'] = "#{order.total.to_i}元"
      end
      template['data']['keyword4']['value'] = order.display_created_at
      template['data']['keyword5']['value'] = order.display_payment_method_names
      Wechat.api.template_message_send Wechat::Message.to(wx_follower.openid).template( template )
    end

  end

  # 杨小姐，充值成功。
  # 本次充值金额：1500
  # 充值后余额：1850
  # 充值门店：武林广场店
  # 汪永峰皮具养护中心(400-0588-222)感谢您的一贯支持。
  def send_deposit_success_message( order, template )
    wx_follower = order.customer.wx_follower
    if wx_follower
      remaining = order.card_transactions.sum(&:amount_remaining)
      template['url'] = "#{Rails.configuration.application['wx_url']}/mp/orders/#{order.id}"
      template['data']['keyword1']['value'] = "#{order.total.to_i}元"
      template['data']['keyword2']['value'] = "#{remaining.to_i}元"
      template['data']['keyword3']['value'] = order.store_name
      Wechat.api.template_message_send Wechat::Message.to(wx_follower.openid).template( template )
    end

  end

  # 订单取消
  # 订单编号：whx67890654fix
  # 订单状态：已取消
  # 汪永峰皮具养护中心(400-0588-222)感谢您的一贯支持。
  def send_order_canceled_message( order, template )
    wx_follower = order.customer.wx_follower
    if wx_follower
      template['url'] = "#{Rails.configuration.application['wx_url']}/mp/orders/#{order.id}"
      template['data']['first']['value'] = (order.order_type_normal? ? "订单取消成功" : "充值取消成功")
      template['data']['keyword1']['value'] = "#{order.number}"
      template['data']['keyword2']['value'] = "已取消"
      Wechat.api.template_message_send Wechat::Message.to(wx_follower.openid).template( template )
    end

  end
end
