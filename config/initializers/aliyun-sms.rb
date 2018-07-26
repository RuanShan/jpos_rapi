Aliyun::Sms.configure do |config|
  puts "Aliyun::Sms#{JPOS_ALIYUN_SMS_ACCESS_KEY_SECRET} "
  config.access_key_secret = JPOS_ALIYUN_SMS_ACCESS_KEY_SECRET
  config.access_key_id = JPOS_ALIYUN_SMS_ACCESS_KEY_ID
  config.action = 'SendSms'                       # default value
  config.format = 'XML'                           # http return format, value is 'JSON' or 'XML'
  config.region_id = 'cn-hangzhou'                # default value
  config.sign_name = JPOS_ALIYUN_SMS_SIGN_NAME
  config.signature_method = 'HMAC-SHA1'           # default value
  config.signature_version = '1.0'                # default value
  config.version = '2017-05-25'                   # default value
end
