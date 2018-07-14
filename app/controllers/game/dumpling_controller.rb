class Game::DumplingController < Game::BaseController
  layout 'dumpling'

  wechat_api

  before_action :set_game_round
end
