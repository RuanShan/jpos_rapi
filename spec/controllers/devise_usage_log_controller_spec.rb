require 'rails_helper'

describe DeviseUsageLogController do
  login_admin

  let(:devise_usage_log_controller) { subject }

  it 'has a current_user' do
    expect(devise_usage_log_controller.current_user).to_not be_nil
  end

  describe '#devise_usage_report' do
    before do
      xhr :post, :devise_usage_report, num_days: 15
    end
    it 'sets number of days (@num_days)' do
      expect(assigns(:num_days)).to eq(15)
    end
    it 'sets list of log entries (@log_entries)' do
      expect(assigns(:log_entries)).to_not be_nil
    end
    it 'renders the devise usage report partial' do
      expect(response).to render_template(partial: 'devise_usage_log/partials/_devise_usage_report')
    end
  end

  describe '#close_devise_usage_report' do
    before do
      xhr :post, :close_devise_usage_report
    end
    it 'renders the devise usage report link partial' do
      expect(response).to render_template(partial: 'devise_usage_log/partials/_devise_usage_report_link')
    end
  end

end
