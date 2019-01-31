module Spree
  class GroupImage < Asset
    include Rails.application.config.use_paperclip ? Configuration::Paperclip : Configuration::ActiveStorage

  end
end
