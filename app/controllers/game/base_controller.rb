class Game::BaseController < ApplicationController
  # 调用 Wechat::ControllerApi，实现多公众号方案。
  # 游戏对应的公众号
  def game_wechat

  end

  def game_wechat_oauth2(scope = 'snsapi_base', page_url = nil, account = nil, &block)

  end

  private

  # initialize wechat account by game_round
  def initialize_wechat_account
  end

end
