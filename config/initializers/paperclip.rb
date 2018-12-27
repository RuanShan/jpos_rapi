Paperclip.interpolates :store_id do |attachment, style_name|
  #belongs to site: product
  #belongs to store: logo, favicon
  attachment.instance.try(:store_id)
end

Paperclip.interpolates :aliyun_host do |attachment, style_name|
  #style_name is symbol
  case style_name
    when :original
      Paperclip::Attachment.default_options[:aliyun][:oss_host]
    else
      Paperclip::Attachment.default_options[:aliyun][:img_host]
  end
end

Paperclip.interpolates :aliyun_style do |attachment, style_name|
  "?x-oss-process=style/#{style_name}"
end
