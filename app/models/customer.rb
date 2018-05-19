class Customer < User
  default_scope { where( is_staff: false ) }

  validates :mobile, presence: true, uniqueness: true

end
