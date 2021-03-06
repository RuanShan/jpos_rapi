module Spree
  class Role < Spree::Base
    has_many :role_users, class_name: 'Spree::RoleUser', dependent: :destroy
    has_many :users, through: :role_users, class_name: 'Spree::User'

    validates :name, presence: true, uniqueness: { case_sensitive: false, allow_blank: true }
  end
end
