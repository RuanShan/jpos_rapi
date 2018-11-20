class UserEntry < ApplicationRecord
  include Spree::RansackableAttributes

  extend BetterDateScope
  better_date_scope day: [:today, :week]

  belongs_to :store, class_name: 'Spree::Store', foreign_key: :store_id, required: true
  belongs_to :user, class_name: 'User', required: true, touch: true

  enum state:{ clockin: 1, clockout: 0 }
  self.whitelisted_ransackable_attributes = %w[id user_id store_id day]

  before_validation :set_today_when_nil
  after_validation  :set_state_when_nil
  validates :day, presence: true

  after_save :touch_user_sale_today

  delegate :username, to: :user
  delegate :name, to: :store, prefix: true

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

    entry.try(:state) == 'clockin' ? 'clockout'  : 'clockin'
  end

  def touch_user_sale_today
    #如果 sale_today不存在，需要创建，
    self.user.sale_today
  end
end
