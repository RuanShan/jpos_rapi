class UserPresenter < BasePresenter
  presents :user

  delegate :id, to: :user
  delegate :role, to: :user

  def find_last_login
    if user.current_sign_in_at
      user.current_sign_in_at
    elsif user.last_sign_in_at
      user.last_sign_in_at
    elsif user.confirmation_sent_at
      user.confirmation_sent_at
    end
  end

  def last_login
    last_login_date = find_last_login
    last_login_date ? (l find_last_login, format: '%Y-%m-%d') : ''
  end

  def last_login_int
    find_last_login.to_i
  end

  def last_ip
    if user.current_sign_in_ip
      str = user.current_sign_in_ip
    elsif user.last_sign_in_ip
      str = user.last_sign_in_ip
    end
    str ? str : ''
  end

  def user_name
    html = []
    if user.role?('admin')
      html << fa_icon('user')
      html << spaces(1)
    end
    html << user.username
    html << spaces(1)
    html << content_tag(:span, t('label.unconfirmed').downcase, class: 'help-block devise') unless user.confirmed?
    safe_join(html)
  end

  def email
    html = []
    html << user.email
    if user.pending_reconfirmation?
      unconfirmed_email = user.unconfirmed_email + ' ' + t('label.pending').downcase
      html << spaces(1)
      html << content_tag(:span, unconfirmed_email, class: 'help-block devise')
    end
    safe_join(html)
  end

  def sign_in_count
    user.sign_in_count > 0 ? user.sign_in_count : ''
  end

  def list_roles_for_select
    list = []
    user.roles.each do |role, _idx|
      next if role == 'admin' && !user.role?('admin')
      list << [role.humanize, role]
    end
    list
  end

end
