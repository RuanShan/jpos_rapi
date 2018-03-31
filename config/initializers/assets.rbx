# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Add additional assets to the asset load path
Rails.application.config.assets.paths << File.join(Rails.root,'vendor','assets', 'images')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  jweixin-1.2.0.js jweixin-1.0.0.js
  ie/ie10-viewport-bug-workaround.js
  case.css case.js
  game_round.css game_round.js
  game_check_in.css game/check_in/all.js
  game_check_in_play.css game_check_in_play.js game_play.js
  common_wechat.js game_round_wechat.css game_round_wechat.js game_counting_wechat.js
  game/skin/style1.css game/screen_money.css
  game/runlin_car_game/all.js game/runlin_car_game/all.css
  game/rl_dumpling/all.js game/rl_dumpling/all.css
  game/yhzy_smp/all.js game/yhzy_smp/all.css
  game/yhzy_ido/all.js game/yhzy_ido/all.css
  game/jlcj_kuaidi/all.js game/jlcj_kuaidi/all.css
  ckeditor/*
)
