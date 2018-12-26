Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  #compile assets for production locally

  config.paperclip_defaults= {
    storage: :aliyun,
    aliyun: {
      access_id: ENV['JPOS_OSS_ACCESS_ID'] ,
      access_key: ENV['JPOS_OSS_ACCESS_SECRET'] ,
      # 你需要在 Aliyum OSS 上面提前创建一个 Bucket
      bucket: 'jpos-img' ,
      # 是否使用内部连接，true - 使用 Aliyun 局域网的方式访问  false - 外部网络访问
      internal: false ,
      # 配置存储的地区数据中心，默认: hangzhou
      data_centre: 'beijing',
      # 使用自定义域名，设定此项，carrierwave 返回的 URL 将会用自定义域名
      # 自定于域名请 CNAME 到 you_bucket_name.oss.aliyuncs.com (you_bucket_name 是你的 bucket 的名称)
      oss_host: "jpos-img.oss-cn-beijing.aliyuncs.com",  # aliyun oss host
      img_host: "jpos-img.oss-cn-beijing.aliyuncs.com",  # aliyun image service host
      # 如果有需要，你可以自己定义上传 host, 比如阿里内部的上传地址和 Aliyun OSS 对外的不同，可以在这里定义，没有需要可以不用配置
      upload_host: "jpos-img.oss-cn-beijing.aliyuncs.com"
    }
  }


end

Paperclip.interpolates :images_host  do |attachment, style|
  # http://localhost:3001"
  "http://localhost"
end

Ransack.configure do |c|
  c.ignore_unknown_conditions = false
end
