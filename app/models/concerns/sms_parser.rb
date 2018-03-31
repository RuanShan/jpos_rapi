#【妈妈驿站】取货码TT6143,快递已到商服圆通如拒签请回电当日取不压电话17604313907投诉电话17604313907
#【韵达快递】货号2F8重要通知：商服韵达有你的快递一直未取，凭新的取货码取件，今日12点前不取退回，关注公众号‘不取快递，2元送到寝
#【汇通快递】货号K103快递已到商服一楼汇通，如拒收请立即联系电话17604313907务必第一时间取走，可代取，以免耽误下批派件，谢谢配合
#【点易达】货号176申通快递请到商服仓库后门12.20前取件拒签打电话13154304767过时统一签超时面单自付全国发件8元每天7点下班
#【京东快递】货号JD2044你好，你的京东快递已到商服中心一楼京东派，请于下午1点前领取，如有事不能来，请您电联：17790078039
#【菜鸟驿站】您的11月20日中通包裹到很久啦，双11包裹多场地有限，请尽快凭取货码（10491）到吉林财经大学商服二楼菜鸟驿站领取
#【微快递】邮政小包:携有效证件当日16:00前凭编码21076号速取！逾期退回！周日休息！商服一楼！微快递下单http://ckd.so/b
#您有一票快件放置于商服一楼请5点半以前，货号100，请持有效证件取件，收派员13104442042。【顺丰速运】
#【快递达】EMS快递请6点前来腾飞驾校取你的包裹拒收回复13944964894 寄件首重全国6元 行李全国一元起
#【快递达】天天快递请于5点前来腾飞驾校取包裹拒收回复13944964894 寄快递首重全国6元 行李全国一元起
#【申通快递】货号85申通快递请到商服仓库后门12.20前取件拒签打电话13154304767过时统一签超时面单自付全国发件8元每天7点下

module SmsParser
  DeliveryVendorReg = /【([\S]+)】/u
  DeliveryCodeRegs = {
    '1号店'=>/(货号|编号|取货码|编码)([\w]+)/u,
    '韵达快递'=>/(货号|编号|取货码|编码)([\w]+)/u,
    '汇通快递'=>/(货号|编号|取货码|编码)([\w]+)/u,
    '点易达'=>/(货号|编号|取货码|编码)([\w]+)/u,
    '京东快递'=>/(货号|编号|取货码|编码)([\w]+)/u,
    '顺丰速运'=>/(货号|编号|取货码|编码)([\w]+)/u,
    '妈妈驿站'=>/(货号|编号|取货码|编码)([\w]+)/u,
    '申通快递'=>/(货号|编号|取货码|编码)([\w]+)/u,
    '菜鸟驿站'=>/(\S)([\w]{3,8})/u,
    '微快递'=>/(货号|编号|取货码|编码)([\w]+)/u,
    '快递达'=>/(】)([\S]+)快递/u, #EMS,天天
   }
   DeliveryAddressRegs = {
     '妈妈驿站'=>/商服([\W]+)如拒签/u,
     '菜鸟驿站'=>/([\W]{2})包裹/u,
     '点易达'=>/货号[\w]+([\W]+)请/,
     '微快递'=>/】([\W]+)\:/u,
     '快递达'=>/来([\S]+)取/u,
   }

  # parse column delivery_sms
  def parse
    vendor=nil, code = nil, address=nil
    if delivery_sms.present?
      vendor = DeliveryVendorReg.match( delivery_sms ).try(:[],1)
      #Rails.logger.debug "vendor=#{vendor}"
      if DeliveryCodeRegs.key? vendor
        code = DeliveryCodeRegs[vendor].match( delivery_sms ).try(:[],2)
      end
      if DeliveryAddressRegs.key? vendor
        address = DeliveryAddressRegs[vendor].match( delivery_sms ).try(:[],1)
      else
        address = vendor
      end
    end
    return vendor, code, address
  end

  def display_delivery_sms
    vendor, code, address = parse
    "#{address}-#{code}"
  end

  def display_delivery_vendor
    vendor, code, address = parse
    vendor
  end

end
