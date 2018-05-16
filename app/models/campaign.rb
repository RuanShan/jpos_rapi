class Campaign < ApplicationRecord
  include CampaignGenre
  extend Spree::DisplayDateTime
  date_time_methods :created_at

  belongs_to :creator, class_name: 'User'
  has_many :game_rounds

  # 表示当前活动的类型
  enum genre:{ live: 0, event: 5, runlin_car_game: 1001, yuhe_photo_contest: 1010 }, _prefix: true

  validates_presence_of :name
end
