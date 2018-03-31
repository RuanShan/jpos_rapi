class WxMpUser < ApplicationRecord
  include Concerns::WxMpUserPlugin
  include Concerns::WeixinApi

  belongs_to :company
  belongs_to :creator, class_name:'User'

  # ['pending', 0, '待激活'],   ['active', 1, '已开启'],    ['disabled', 2, '已过期，待激活'],    ['froze', -1, '已冻结']
  enum status: { pending: 0, active: 1,   disabled: 2,  froze: 4 }, _prefix: true
  # ['subscribe', 1, '订阅号'],    ['auth_subscribe', 2, '认证订阅号'],    ['service', 3, '服务号'],    ['auth_service', 4, '认证服务号'] ]
  enum service_type: { subscribe: 1, auth_subscribe: 2, service: 3, auth_service: 4, unknown: 0 }, _prefix: true
  # ['cancel', -1, '取消'],    ['manual', 1, '默认'],    ['plugin', 2, '插件']
  enum bind_type: { cancel: 4, manual: 1,  plugin: 2 }, _prefix: true

end
