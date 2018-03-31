# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


User.where(username: 'admin')
    .first_or_create(username: 'admin', email: 'admin@example.com', role: 'admin',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)
User.where(username: 'manager')
    .first_or_create(username: 'manager', email: 'manager@example.com', role: 'manager',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)
User.where(username: 'guest')
    .first_or_create(username: 'guest', email: 'guest@example.com', role: 'guest',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)
User.where(username: 'test')
    .first_or_create(username: 'test', email: 'test@example.com', role: 'user',
                     password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)

User.where(username: 'yhzy')
    .first_or_create(username: 'yhzy', email: 'yhzy@example.com', role: 'user',
                    password: '123123', password_confirmation: '123123', confirmed_at: Time.zone.now)

Game.code_check_in.where( name: '签到抽奖').first_or_create
Game.code_tug.where( name: '摇一摇拔河' ).first_or_create
Game.code_counting.where( name: '数钱小能手' ).first_or_create
Game.code_runlin_car_game.where( name: '大众高尔夫汽车游戏' ).first_or_create
Game.code_runlin_dumpling.where( name: '新春go年货' ).first_or_create
Game.code_yhzy_smp.where( name: '艺海朝阳撕名牌', wx_oauth2_scope: :snsapi_base ).first_or_create
Game.code_yhzy_ido.where( name: '艺海朝阳IDO', wx_oauth2_scope: :snsapi_base ).first_or_create
Game.code_yhzy_jhj.where( name: '艺海朝阳结婚机', wx_oauth2_scope: :snsapi_base ).first_or_create
Game.code_jlcj_kuaidi.where( name: '吉林财经快递' ).first_or_create

WechatAccount.where( name:'Test', original_id: 'gh_ab13fa74989d',appid: 'wxe1e41bc95e1ffc98', appsecret: '5ed88d0faa88ba705a31e650791c5d85').first_or_create
