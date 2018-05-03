class Customer < User
  default_scope { where( is_staff: false ) }
end
