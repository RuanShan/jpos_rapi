class UserEntry < ApplicationRecord
  extend BetterDateScope
  better_date_scope day: [:today, :week]

  belongs_to :store, class_name: 'Spree::Store', foreign_key: :store_id, required: true
  belongs_to :user, class_name: 'User', required: true

  enum state:{ checkin: 1, checkout: 0 }

  before_validation :set_today_when_nil
  validates :day, presence: true

  private
  def set_today_when_nil
    self.day = DateTime.current.to_date if self.day.nil?
  end

end
