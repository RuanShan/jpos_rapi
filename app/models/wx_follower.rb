class WxFollower < ApplicationRecord

  belongs_to :customer,  required: false
  validates :mobile, mobile: true , if: :mobile_validatable
  validate :customer_mobile_required, if: :mobile_validatable, on: :create
  before_create :associate_customer



  private
  def associate_customer
    self.customer = Customer.where( mobile: self.mobile ).first
  end

  def customer_mobile_required
    unless Customer.exists?( mobile: self.mobile)
      self.errors.add( 'mobile', '会员手机号码不存在，请咨询门店')
    end
  end

  def mobile_validatable
    self.mobile.present?
  end
end
