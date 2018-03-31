require 'fileutils'

module WechatOpen
  class << self
    def cache
      return @cache if defined? @cache
      @cache = ActiveSupport::Cache.lookup_store(WechatOpen.config.cache_store)
      @cache
    end
  end
end
