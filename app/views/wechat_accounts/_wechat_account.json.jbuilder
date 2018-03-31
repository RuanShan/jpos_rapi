json.extract! wechat_account, :id, :name, :account, :key, :secret, :access_token, :created_at, :updated_at
json.url wechat_account_url(wechat_account, format: :json)