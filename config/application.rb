require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsStarter
  class Application < Rails::Application
    require "active_storage/engine"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #https://www.phusionpassenger.com/library/config/standalone/action_cable_integration/
    # Serve websocket cable requests in-process
    config.application = config_for(:application)



    # Custom directories with classes and modules you want to be autoloadable.
    #config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/api)
    config.autoload_paths += %w( app/api app/validators app/services lib ).map { |path| "#{Rails.root}/#{path}" }

    #config.eager_load_paths += Dir["#{Rails.root}/lib/*.rb"]

    config.generators.assets = false

    config.active_job.queue_name_prefix = Rails.env
    #config.active_job.queue_adapter = :sidekiq

    config.time_zone = 'Beijing'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :"zh-CN"


    config.middleware.insert_before 0, Rack::Cors do
      allow do
        #localhost is required for electron
        origins  /localhost(:\d+)/, /127.0.0.1(:\d+)/, /192.168./, /wyfpj/
        resource '*', :headers => :any, :methods => [:get, :post, :delete, :put, :patch, :options, :head], :credentials => true
        #resource '/api/v1/*', :headers => :any, :methods => [:get, :post, :delete, :put, :patch, :options, :head], :credentials => true
        #resource '/users/*', :headers => :any, :methods => [:get, :post, :delete, :options], :credentials => true
        #resource '/user_entries/*', :headers => :any, :methods => [:get, :post, :delete, :options], :credentials => true
        #resource '/sms*', :headers => :any, :methods => [:get, :post, :delete, :options], :credentials => true
      end
    end

    initializer "spree.spree_pos.preferences", :after => "spree.environment" do |app|
      #SpreePos::Config = SpreePos::Configuration.new
      #::CARD_TYPE = ['Visa', 'MasterCard', 'Verve', 'AmericanExpress', 'China UnionPay']
      #app.config.spree.payment_methods << Spree::PaymentMethod::PointOfSale
    end
  end
end
