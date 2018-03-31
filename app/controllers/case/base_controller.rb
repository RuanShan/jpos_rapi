module Case
  class BaseController < ApplicationController
    CASE_BEFORE_ACTIONS = [:authenticate_user!, :require_wx_mp_user]

    before_action *CASE_BEFORE_ACTIONS
    layout 'case'


    def require_wx_mp_user
      @wx_mp_user = current_company.wx_mp_users.first || WxMpUser.create(creator_id: current_user.id, company_id: current_company.id)
      # return redirect_to platforms_path, alert: '请先添加微信公共帐号' unless @wx_mp_user
    end

    def render_csv_header(filename = nil)
      filename ||= params[:action]
      filename += '.csv'
      if request.env['HTTP_USER_AGENT'] =~ /msie/i
        headers['Pragma'] = 'public'
        headers["Content-type"] = "text/plain"
        headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
        headers['Expires'] = "0"
      else
        headers["Content-Type"] ||= 'text/csv'
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
      end
    end

  end
end
