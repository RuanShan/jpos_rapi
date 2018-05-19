class Employee < User
  default_scope { where( is_staff: true ) }

end
