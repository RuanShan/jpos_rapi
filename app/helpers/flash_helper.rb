module FlashHelper

  def flash_messages
    bootstrap_flash_type = {notice: 'info', alert: 'warning', error: 'danger', success: 'success'}
    messages = []
    flash.each do |key, msg|
      next if msg.blank?
      next unless msg.is_a? String
      bootstrap_class = "alert fade show alert-#{bootstrap_flash_type[key.to_sym]}"
      # rubocop:disable Rails/OutputSafety
      button = content_tag(:button, raw('&times;'), class: 'close', data: {dismiss: 'alert'})
      messages << content_tag(:div, button + msg.html_safe, class: bootstrap_class)
      # rubocop:enable Rails/OutputSafety
    end
    flash.clear # empty so doesn't linger
    safe_join(messages, "\n")
  end

end
