  site = Spree::Site.find_or_create_by(name: '汪永峰皮具养护中心')
  site.sms_templates = [
    {cname: '验证码', name:'verify_mobile', code:'SMS_144151564', desc: '您正在申请手机注册，验证码为：XXXX，5分钟内有效！'},
    {cname: '发送会员卡密码', name:'send_password', code:'SMS_151772113', desc: '您好，您的密码为XXXX，请打死也不要告诉任何人。'}]
  site.save
  Spree::Store.update_all site_id: site.id
