class Activity < ApplicationRecord
  extend Spree::DisplayDateTime
  date_time_methods :created_at

  belongs_to :creator, class_name: 'User'
end
