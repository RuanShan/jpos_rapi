module Spree
  class Store < Spree::Base
    thread_mattr_accessor :current
    belongs_to :site, class_name: 'Spree::Site'

    has_many :orders, class_name: 'Spree::Order'
    has_many :line_item_groups, class_name: 'Spree::LineItemGroup'
    has_one :address, class_name: 'Spree::Address'
    belongs_to :stock_location, class_name: 'Spree::StockLocation'
    has_many :customers, class_name: 'Customer'
    has_many :sale_days, class_name: 'SaleDay'

    with_options presence: true do
      validates :code, uniqueness: { case_sensitive: false, allow_blank: true }
      validates :name
    end

    before_save :ensure_default_exists_and_is_unique
    before_destroy :validate_not_default

    scope :by_url, ->(url) { where('url like ?', "%#{url}%") }

    after_commit :clear_cache

    delegate :sms_templates,:has_factory, to: :site, prefix: true

    self.whitelisted_ransackable_attributes = %w[site_id]

    private

    def ensure_default_exists_and_is_unique
      if default
        Store.where.not(id: id).update_all(default: false)
      elsif Store.where(default: true).count.zero?
        self.default = true
      end
    end

    def validate_not_default
      if default
        errors.add(:base, :cannot_destroy_default_store)
        throw(:abort)
      end
    end

    def clear_cache
      Rails.cache.delete('default_store')
    end
  end
end
