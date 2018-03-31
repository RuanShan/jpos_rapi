# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  image_url              :string(255)
#  role                   :string(255)      default("guest")
#  username               :string(255)      default(""), not null
#

require 'rails_helper'

describe User do

  describe '#role?' do
    it 'returns true since a manager has a same or greater role than a user' do
      user = create(:user, role: 'manager')
      expect(user.role?('user')).to be_truthy
    end
    it 'returns false since a user does not have the same as a manager' do
      user = create(:user, role: 'user')
      expect(user.role?('manager')).to be_falsey
    end
  end

  describe '#avatar_url' do
    it "return user's image_url when set" do
      user = create(:user, image_url: 'this/that.jpg')
      expect(user.avatar_url).to eq('this/that.jpg')
    end
    it 'return link to gravatar if image_url not set' do
      user = create(:user, image_url: nil)
      expect(user.avatar_url).to match(/gravatar.com/)
    end
  end

  describe '#log_devise_action' do
    it 'creates a DeviseUsageLog record' do
      user = create(:user)
      expect do
      end.to change(DeviseUsageLog, :count)
    end
    it 'creates a DeviseUsageLog record for this user' do
      user = create(:user)
      user.log_devise_action(DeviseAction::Login)
      log_entry = DeviseUsageLog.last
      expect(log_entry.user_id).to eq(user.id)
    end
  end

  describe 'new_with_password' do
    it 'returns a new user record all set for a Devise change password email' do
      user = User.new_with_password(username: 'gabby', email: 'gabby@example.com')
      expect(user.encrypted_password).to_not be_empty
      expect(user.reset_password_token).to_not be_empty
    end
  end
end
