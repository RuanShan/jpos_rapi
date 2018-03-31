require 'i18n'

namespace :devise_usage do

  desc 'quick list of last 10 days of devise usage'
  task :report, [:exclude_ip] => :environment do |_t, args|

    I18n.enforce_available_locales = false
    exclude_ip = args[:exclude_ip] || ''

    printf("\nDevise Usage Log - %s (previous 10 days)\n",
           Time.zone.now.strftime('%m/%d/%Y'))
    printf("=================================================\n")

    entries = DeviseUsageLog.where('created_at > ?', Time.zone.now - 10.days)
                            .order('devise_usage_logs.created_at desc')
                            .order('user_id')

    previous_date_string = ''
    entries.each do |entry|
      current_date_string = entry.created_at.strftime('%m/%d/%Y')
      printf "\n%s:\n-----------\n", current_date_string if current_date_string != previous_date_string
      unless (exclude_ip.present? && entry.user_ip == exclude_ip) || entry.action.blank?
        printf "USER: %-12s IP: %-15s ROLE: %-8s ACTION: %s\n",
               entry.username.present? ? entry.username : '(unknown)',
               entry.user_ip,
               entry.role,
               "#{I18n.t(entry.action, scope: 'classy_enum.devise_action')} (#{entry.created_at.strftime('%H:%M')})"
      end
      previous_date_string = current_date_string
    end
  end

end
