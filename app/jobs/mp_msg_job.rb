class MpMsgJob < ApplicationJob
  queue_as :message


  def perform( order )
      Rails.logger.error " send mp message  #{order.number}"
      template_id = "eEFREBXW8XkD4Rvj-cTuPkrdlUEA3sp5TXAvTwR_d74"

      template_yaml_path = File.join( Rails.root, 'config', 'wechat_template.yml')

      template = YAML.load(File.read(template_yaml_path))
      #Wechat.api.template_message_send Wechat::Message.to(openid).template(template['template'])


  end
end
