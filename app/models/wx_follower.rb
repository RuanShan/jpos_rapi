class WxFollower < ApplicationRecord
  belongs_to :customer,  required: false

end
