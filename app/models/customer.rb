class Customer < User
  default_scope { where( is_staff: true ) }
end
