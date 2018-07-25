class WxFollower < ApplicationRecord

  belongs_to :customer,  required: false


  validates :mobile, mobile: true , if: :mobile_validatable
  validate :customer_mobile_required, if: :mobile_validatable




  private

  def customer_mobile_required
    unless Customer.exist?( mobile: self.mobile)

    end
  end

  def mobile_validatable
    self.mobile.present?
  end
end
