# == Schema Information
#
# Table name: devise_usage_logs
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  user_ip    :string(255)
#  role       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  username   :string(255)
#  action     :string(255)
#

require 'rails_helper'
include Warden::Test::Helpers

describe DeviseUsageLog do

  let!(:current_user) { create(:user, role: 'user') }
  let!(:user) { create(:user, username: 'molly', email: 'molly@example.com') }
  before do
    login_as current_user
  end

  it 'has a valid factory' do
    expect(create(:devise_usage_log)).to be_valid
  end

  it '#fetch_usage_report_entries returns selection' do
    allow(Rails.application.config).to receive(:devise_usage_log_level).and_return(:all)
    response = DeviseUsageLog.fetch_usage_report_entries
    expect(response.count).to eq(2)
  end

  describe '#log' do
    it 'does nothing if :devise_usage_log_level is not set' do
      allow(Rails.application.config).to receive(:devise_usage_log_level).and_return(nil)
      expect do
      end.to_not change(DeviseUsageLog, :count)
    end
    it 'logs if level is :all' do
      allow(Rails.application.config).to receive(:devise_usage_log_level).and_return(:all)
      expect do
      end.to change(DeviseUsageLog, :count)
    end
    it 'logs if level is :login and action is login' do
      allow(Rails.application.config).to receive(:devise_usage_log_level).and_return(:login)
      expect do
      end.to change(DeviseUsageLog, :count)
    end
    it 'does nothing if :login but not login action' do
      allow(Rails.application.config).to receive(:devise_usage_log_level).and_return(:none)
      expect do
      end.to_not change(DeviseUsageLog, :count)
    end
  end
end
