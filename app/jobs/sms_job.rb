class SmsJob < ApplicationJob
  TemplateTypeEnum = Struct.new( "MpTemplateType", "new_order_created", "deposit_success", "order_canceled")['new_order_created', "deposit_success", "order_canceled"]
  queue_as :message

  def perform( order, sms_type)
      Rails.logger.error " send sms #{order.number}"
    if sms_type == TemplateTypeEnum.new_order_created
      usermobile = order.user.mobile
      if usermobile.present?
        storename = order.store_name
        ordernumber = order.number
        SmsService.send_order_created(usermobile, storename, ordernumber )
      end
    end
  end
end
