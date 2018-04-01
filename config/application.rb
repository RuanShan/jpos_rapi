require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsStarter
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #https://www.phusionpassenger.com/library/config/standalone/action_cable_integration/
    # Serve websocket cable requests in-process

    config.generators do |generator|
      generator.test_framework :rspec,
                               fixtures: true,
                               view_specs: false,
                               helper_specs: true,
                               routing_specs: false,
                               controller_specs: true,
                               request_specs: false
      generator.fixture_replacement :factory_girl, dir: 'spec/factories'
    end


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
        origins /localhost(:\d+)/, /127.0.0.1(:\d+)/
        resource '/api/v1/*', :headers => :any, :methods => [:get, :post, :delete, :put, :patch, :options, :head], :credentials => true
        resource '/users/*', :headers => :any, :methods => [:get, :post, :options], :credentials => true
      end
    end

  end
end
