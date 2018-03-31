class DeviseUsageLogController < ApplicationController
 
  before_action :authenticate_user!
  before_action do |chk|
    chk.send(:check_access_level, 'admin')
  end

  def devise_usage_report
    @num_days = 10 # default
    if params[:num_days]
      @num_days = params[:num_days].to_i if params[:num_days].to_i.between?(1, 60)
    end
    @log_entries = DeviseUsageLog.fetch_usage_report_entries(@num_days)

    respond_to do |format|
      format.html { redirect_to admin_path }
      format.js
    end
  end

  def close_devise_usage_report
    respond_to do |format|
      format.html { redirect_to admin_path }
      format.js
    end
  end

end
