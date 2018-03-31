require 'wechat_open/version'
require 'wechat_open/configuration'
require 'wechat_open/cache'
require 'wechat_open/binding'

module WechatOpen

  class << self
    def config
      return @config if defined?(@config)
      @config = Configuration.new
      #@config.style       = :colorful
      #@config.expires_in  = 2.minutes
      if Rails.application
        @config.cache_store = Rails.application.config.cache_store
      else
        @config.cache_store = :mem_cache_store
      end
      @config.cache_store
      @config
    end

    def configure(&block)
      config.instance_exec(&block)
    end

    def check_cache_store!
      cache_store = WechatOpen.config.cache_store
      store_name = cache_store.is_a?(Array) ? cache_store.first : cache_store
      if [:memory_store, :null_store, :file_store].include?(store_name)
        WechatOpen.config.cache_store = [:file_store, Rails.root.join('tmp/cache/wechat_open')]

        puts "

  WechatOpen's cache_store requirements are stored across processes and machines,
  such as :mem_cache_store, :redis_store, or other distributed storage.
  But your current set is #{cache_store}, it has changed to :file_store for working.
  NOTE: :file_store is still not a good way, it only works with single server case.

"
      end
    end
  end
end
