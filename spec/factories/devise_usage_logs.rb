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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :devise_usage_log do
    user_id 1
    user_ip '100.100.100.100'
    role 'user'
    username 'jane'
  end
end
