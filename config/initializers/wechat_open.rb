WechatOpen.configure do
  self.cache_store = [:file_store, Rails.root.join('tmp/cache/wechat_open')]
end
