class Company < ApplicationRecord
  has_many :wx_mp_users, class_name:'WxMpUser'
end
