class DashboardController < ApplicationController
  before_action :authenticate_user!

  

  def index
    @games = Game.all

  end
end
