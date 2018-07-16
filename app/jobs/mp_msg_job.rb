class MpMsgJob < ApplicationJob
  queue_as :message


  def perform( order )
      Rails.logger.error " send mp message  #{order.number}"
  end
end
