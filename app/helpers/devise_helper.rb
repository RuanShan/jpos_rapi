module DeviseHelper

  # override to make formatting more friendly
  def devise_error_messages!
    format_user_error_messages(resource)
  end

  def format_user_error_messages(resource)
    return '' if resource.errors.empty?
    msgs = resource.errors.full_messages
    resource.errors.clear # empty out error messages so they don't linger
    content_tag :div, class: 'alert fade show alert-danger' do
      devise_close_button + devise_errors_list(msgs)
    end
  end

  private

  def devise_errors_list(msgs)
    content_tag :ul do
      msgs.map { |msg| concat(content_tag(:li, msg.html_safe)) } # rubocop:disable Rails/OutputSafety
    end
  end

  def devise_close_button
    content_tag(:button, raw('&times;'), class: 'close', data: {dismiss: 'alert'}) # rubocop:disable Rails/OutputSafety
  end

end
