class Customer <  ApplicationRecord

  acts_as_paranoid
  include Spree::RansackableAttributes
  extend Spree::DisplayDateTime
  include Spree::CustomerReporting


  after_destroy :scramble_mobile_and_password # mobile is uniqueness

  validates :mobile, presence: true, uniqueness: true

  belongs_to :creator, class_name: 'User', foreign_key: 'created_by_id', optional: true
  belongs_to :store, class_name: 'Spree::Store'
  #服务员创建新会员的日子，一天新注册了多少用户统计
  belongs_to :sold_day, ->{ today.where( store: Spree::Store.current ) }, class_name: 'SaleDay', counter_cache: 'new_customers_count',
    primary_key: 'user_id', foreign_key: 'created_by_id', optional: true

  # 包括客户 消费订单 和 购买会员卡，会员卡充值订单
  has_many :orders, class_name: 'Spree::Order', foreign_key: 'user_id'
  has_many :cards, class_name: 'Spree::Card', foreign_key: 'user_id', inverse_of: :customer
  #用户当前可用充值卡
  has_one  :prepaid_card, ->{ status_enabled.style_prepaid }, class_name: 'Spree::Card', foreign_key: 'user_id'
  has_one  :wx_follower

  accepts_nested_attributes_for :cards

  has_one :wx_follower, inverse_of: :customer

  self.whitelisted_ransackable_attributes = %w[id mobile username store_id]
  self.whitelisted_ransackable_associations = %w[cards]

  before_validation :set_defaults
  alias_attribute :name, :username # order.user_name required

  date_time_methods :created_at, :updated_at

  enum gender: { male: 1, female: 0 }

  delegate :name, to: :store, prefix: true
  delegate :nickname, :headimgurl, to: :wx_follower, prefix: true, allow_nil: true

  # sms对象，创建用户时检查短信验证码, :verify_code, 用户输入的验证码
  attr_accessor :sms,:verify_code

  #总共消费金额
  def normal_order_total
    orders.where( order_type: :normal ).sum(:total)
  end
  #总共消费次数
  def normal_order_count
    orders.where( order_type: :normal ).count
  end

  # 客户当前使用的充值卡
  #def prepaid_card
  #  self.cards.status_enabled.style_prepaid.first
  #end

  def display_name
    name.present? ? name : I18n.t( 'customer_without_name')
  end

  private

    def set_defaults
      # for now force login to be same as email, eventually we will make this configurable, etc.
      self.username = self.mobile if (self.mobile.present? && self.username.blank? )
      self.number = generate_permalink if self.number.blank?
    end

    def scramble_mobile_and_password
      self.mobile = SecureRandom.uuid + "@wyfpj.com"
      self.username = self.mobile
      self.password = SecureRandom.hex(8)
      self.password_confirmation = self.password
      self.save
    end

    # 会员号 {2位店号}{5位随机数}
    def generate_permalink()
      length = 7
      loop do
        candidate = new_candidate(length)
        return candidate unless self.class.exists?(number: candidate)

        # If over half of all possible options are taken add another digit.
        length += 1 if host.count > Rational(10**length, 2)
      end
    end

    def new_candidate(length)
      prefix = "M%02d" % [ self.store_id ]
      characters = 10
      prefix + SecureRandom.random_number(characters**length).to_s(characters).rjust(length, '0').upcase
    end

    def confirm_verify_code
      #只有sms存在时才需要验证，加载seed时无需短信验证
      if sms.present?
        if !sms.validate_for_sign_up( self.cellphone, self.verify_code)
          Rails.logger.debug sms.errors.inspect
          errors.add("verify_code", sms.errors.first[1])
        end
      end
    end

end
