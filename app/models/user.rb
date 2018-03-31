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

  devise :database_authenticatable, :registerable, :confirmable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable # , :omniauthable

  validates :username, uniqueness: true, length: {within: 4..12}

  belongs_to :company
  has_many :game_rounds, foreign_key: :creator_id

  before_create :generate_api_token

  ROLES = {'guest' => 1, 'user' => 2, 'manager' => 3, 'admin' => 4}.freeze

  def self.new_with_password(user_params)
    pwd = SecureRandom.hex(8)
    # use a reset_password_token to force password creation on confirmation
    _raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    options = {username: user_params[:username], email: user_params[:email],
               password: pwd, password_confirmation: pwd, reset_password_token: enc, role: 'user'}
    new(options)
  end


  def roles
    ROLES
  end

  def role?(base_role)
    ROLES[role.to_s] >= ROLES[base_role.to_s.downcase]
  end

  # def role_is?(test_role)
  #   role == test_role
  # end

  def avatar_url
    return image_url if image_url?
    gravatar_id = Digest::MD5::hexdigest(email).downcase # rubocop:disable all
    "http://gravatar.com/avatar/#{gravatar_id}.png?r=g&s=30&d=mm"
  end

  def user_exists_but_force_password_reset?
    return true if id && confirmed_at.present? && reset_password_token.present? && \
                   last_sign_in_at.blank? && last_sign_in_ip.blank?
    false
  end

  def self.valid_user?(resource)
    resource && resource.is_a?(User) && resource.valid?
  end

  def log_devise_action(new_action)
    DeviseUsageLog.create!(user_id: id, role: role, user_ip: current_sign_in_ip, username: username, action: new_action)
  end


  def reset_api_token!
    generate_api_token
    save
  end

  private

  def generate_api_token
    loop do
      self.api_token = SecureRandom.base64(64)
      break if !User.find_by(api_token: api_token)
    end
  end



end
