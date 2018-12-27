  site = Spree::Site.find_or_create_by(name: '汪永峰皮具养护中心')
  site.sms_templates = [{cname: '验证码', name:'verify_mobile', code:'SMS_144151564'},
    {cname: '验证码', name:'verify_mobile', code:'SMS_144151564'},
    {cname: '发送会员卡密码', name:'send_password', code:'SMS_151772113'}]
  site.save
  Spree::Store.update_all site_id: site.id
