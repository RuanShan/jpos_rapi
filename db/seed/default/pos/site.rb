  site = Spree::Site.find_or_create_by(name: '汪永峰皮具养护中心')
  site.sms_templates = [
    {cname: '新年祝福', name:'happy_new_year', code:'SMS_153995264', desc: '“软语裁春雪，山色倚晴空”，大连软山全体员工感谢您的信赖与支持。新春到来之际，祝您新年快乐，阖家幸福，万事如意。'},

  ]
  site.save
  Spree::Store.update_all site_id: site.id
