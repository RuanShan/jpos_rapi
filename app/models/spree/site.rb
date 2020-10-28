module Spree
  class Site <  Spree::Base
    # create_table "sms_templates"  do |t|
    #   t.reference :store
    #   t.string :channel  #费用名称
    #   t.string :name   #备注
    #   t.string :code   #备注
    #   t.integer :style, null: false, default: 0 #模版类型  0验证码 1:短信通知
    #   t.integer :state, null: false, default: 0 #费用状态  :正常，:取消
    #   t.timestamps null: false
    # end
    thread_mattr_accessor :current
    has_many :stores, class_name: 'Spree::Store'

    serialize :sms_templates, JSON
  end
end
