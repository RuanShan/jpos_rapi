class UserEntry < ApplicationRecord
  extend BetterDateScope
  better_date_scope day: [:today, :week]

  belongs_to :store, class_name: 'Spree::Store', foreign_key: :store_id, required: true
  belongs_to :user, class_name: 'User', required: true

  enum state:{ checkin: 1, checkout: 0 }

  before_validation :set_today_when_nil
  after_validation  :set_state_when_nil
  validates :day, presence: true

  delegate :username, to: :user

  private
  def set_today_when_nil
    self.day = DateTime.current.to_date if self.day.nil?
  end

  def set_state_when_nil
    self.state = compute_next_state if self.state.nil?
  end

  # 根据用户今天的登录记录，得出下一个记录的状态
  def compute_next_state
    entry = self.user.user_entries.today.last

    entry.try(:state) == 'checkin' ? 'checkout'  : 'checkin'
  end

end
