module Spree
  class Store < Spree::Base

    has_many :orders, class_name: 'Spree::Order'
    has_many :line_item_groups, class_name: 'Spree::LineItemGroup'
    has_one :address, class_name: 'Spree::Address'
    belongs_to :stock_location, class_name: 'Spree::StockLocation'

    with_options presence: true do
      validates :code, uniqueness: { case_sensitive: false, allow_blank: true }
      validates :name
    end

    before_save :ensure_default_exists_and_is_unique
    before_destroy :validate_not_default

    scope :by_url, ->(url) { where('url like ?', "%#{url}%") }

    after_commit :clear_cache
    class << self
      def current(domain = nil)
        #Store.default is for test only
        ::Thread.current[:store] || Store.default
      end

      def current=(store)
        ::Thread.current[:store] = store
      end

      def default
        Rails.cache.fetch('default_store') do
          where(default: true).first_or_initialize
        end
      end
    end
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
