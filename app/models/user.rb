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

class User < ActiveRecord::Base
  ROLES = {'guest' => 1, 'user' => 2, 'manager' => 3, 'admin' => 4}.freeze
  extend Spree::DisplayDateTime

  include Spree::UserAddress
  include Spree::UserPaymentSource
  include Spree::UserMethods



  devise :database_authenticatable, :registerable, :recoverable, :lockable, :timeoutable,
         :rememberable, :trackable, :validatable, :encryptable, :encryptor => 'authlogic_sha512'

  acts_as_paranoid
  after_destroy :scramble_email_and_password


  belongs_to :store, class_name: 'Spree::Store'

  #服务员今天的统计信息
  has_one :sale_today, ->{ today.where( store: Spree::Store.current ) }, class_name: 'SaleDay', foreign_key: 'user_id'
  has_many :sale_days, class_name: 'SaleDay'

  after_initialize :create_sale_today_for_waiter, :if => :persisted?
  before_validation :set_login

  users_table_name = User.table_name
  roles_table_name = Spree::Role.table_name

  scope :admin, -> { includes(:spree_roles).where("#{roles_table_name}.name" => "admin") }

  self.whitelisted_ransackable_attributes = %w[id mobile username]
  self.whitelisted_ransackable_associations = %w[spree_roles]

  alias_attribute :spree_api_key, :api_key
  alias_attribute :name, :username # order.user_name required

  date_time_methods :created_at, :updated_at

  validates :username, presence: true, length: { in: 5..20 }, uniqueness: true

  def self.admin_created?
    User.admin.count > 0
  end

  def admin?
    has_spree_role?('admin')
  end

  def avatar_url
    "xx"
  end
  protected
    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end

  private
    # override Devise::Trackable
    def update_tracked_fields!(request)
      # We have to check if the user is already persisted before running
      # `save` here because invalid users can be saved if we don't.
      # See https://github.com/plataformatec/devise/issues/4673 for more details.
      return if new_record?

      update_tracked_fields(request)

      self.last_request_at = self.current_sign_in_at
      save(validate: false)
    end

    def set_login
      # for now force login to be same as email, eventually we will make this configurable, etc.
      self.username = self.mobile if (self.mobile.present? && self.username.blank? )
    end

    def scramble_email_and_password
      self.email = SecureRandom.uuid + "@example.net"
      self.username = self.mobile
      self.password = SecureRandom.hex(8)
      self.password_confirmation = self.password
      self.save
    end

    def create_sale_today_for_waiter
        self.create_sale_today( store_id: store_id ) if self.sale_today.blank?
    end

    def recompute_processed_line_items_count( date )
      sale_day = sale_days.on_date( date ).first
      sale_day.recompute_processed_line_items_count
    end
  #
  #
  # def self.new_with_password(user_params)
  #   pwd = SecureRandom.hex(8)
  #   # use a reset_password_token to force password creation on confirmation
  #   _raw, enc = Devise.token_generator.generate(User, :reset_password_token)
  #   options = {username: user_params[:username], email: user_params[:email],
  #              password: pwd, password_confirmation: pwd, reset_password_token: enc, role: 'user'}
  #   new(options)
  # end
  #
  #
  # def roles
  #   ROLES
  # end
  #
  # def role?(base_role)
  #   ROLES[role.to_s] >= ROLES[base_role.to_s.downcase]
  # end
  #
  # # def role_is?(test_role)
  # #   role == test_role
  # # end
  #
  # def avatar_url
  #   return image_url if image_url?
  #   gravatar_id = Digest::MD5::hexdigest(email).downcase # rubocop:disable all
  #   "http://gravatar.com/avatar/#{gravatar_id}.png?r=g&s=30&d=mm"
  # end
  #
  # def user_exists_but_force_password_reset?
  #   return true if id && confirmed_at.present? && reset_password_token.present? && \
  #                  last_sign_in_at.blank? && last_sign_in_ip.blank?
  #   false
  # end
  #
  # def self.valid_user?(resource)
  #   resource && resource.is_a?(User) && resource.valid?
  # end
  #
  # def log_devise_action(new_action)
  #   DeviseUsageLog.create!(user_id: id, role: role, user_ip: current_sign_in_ip, username: username, action: new_action)
  # end
  #
  #

  def email_required?
    false
  end

end
