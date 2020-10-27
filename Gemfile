source 'https://gems.ruby-china.com/' do
################################################################################
# spree
################################################################################
gem 'spree_core',   path: './spree/core'
gem 'spree_api',   path: './spree/api'
gem 'spree_backend',   path: './spree/backend'


################################################################################
  gem 'rails', '~> 5.2.0'
  gem 'rack-cors', :require => 'rack/cors'

  gem 'mysql2', '~> 0.4.10'

  # Use Puma as the app server
  gem 'puma', '~> 5.0'

  gem 'sass-rails', '~> 5.0.7'
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.2'
  #gem 'therubyracer', platforms: :ruby
  #gem "haml-rails"
  gem 'jquery-rails'
  #gem 'jquery-ui-rails'

  gem 'turbolinks'
  #gem 'jquery-turbolinks'
  gem 'mini_magick'

  gem 'jbuilder', '~> 2.0'

  gem 'bootstrap-sass', '~> 3.3.7'
  gem "font-awesome-rails"
  #https://github.com/kyuubi9/rails-adminlte
  #gem 'rails-adminlte'
  #add it for window
  #gem 'bcrypt-ruby', '3.1.5', :require => 'bcrypt', platforms: [:ruby]
  gem 'devise'
  #spree_auth_devise spree_user required
  gem 'devise-encryptable', '0.1.2'

  #gem 'cancancan'
  #gem 'classy_enum', '~> 3.4'
  # spree require 5.1.0
  gem 'paperclip', '~> 6.0.0'
  gem 'paperclip_oss_storage',   github: 'RuanShan/paperclip_oss_storage', branch: 'master'
  gem 'activestorage-aliyun', '~> 0.6.4'

  #gem "friendly_id"
  #gem 'figaro'

  gem 'wechat', '~> 0.10.3' #, :github => "Eric-Guo/wechat", :branch => "master"
  gem 'wx_pay'

  gem 'simple_form'
  gem 'aasm' # https://github.com/aasm/aasm State machines for Ruby classes
  gem 'ckeditor' #富文本编辑器

  #redis client
  gem 'redis', '~> 3.0'
  #cache store
  gem 'redis-rails'

  gem 'sidekiq'
  #字段搜索
  #gem 'ransack'
  #验证码
  #gem 'rucaptcha'
  #https://github.com/nesquena/rabl/wiki/Rabl-In-Production
  gem 'aliyun-sms'

  group :doc do
    # bundle exec rake doc:rails generates the API under doc/api.
    gem 'sdoc', require: false
  end

  group :development do
    gem 'capistrano', '~> 3.2.0', require: false
    gem 'capistrano-rails', '~> 1.1', require: false
    gem 'capistrano-bundler', '~> 1.1', require: false

    # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
    #gem 'web-console'
    gem 'listen', '~> 3.0.5'
    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem 'spring'
    gem 'spring-watcher-listen', '~> 2.0.0'

    gem 'pry', require:false
    gem 'pry-rails', :group => :development

    gem 'reek', '~> 4', require: false
  end

  #gem 'wechat_open',   path: './wechat_open'
  gem 'httparty'
  gem 'rest-client'
  gem 'tzinfo-data', platforms: [:mingw, :mswin , :x64_mingw]

  gem 'kaminari'

end

#source 'https://rails-assets.org' do
#  gem 'rails-assets-footable', '2.0.3'
#  gem 'rails-assets-tether', '>= 1.1.0'
#end
