class SmsJob < ApplicationJob
  queue_as :message

  def perform( order )
      Rails.logger.error " send sms #{order.number}"
  end
end
