class VisitorsController < ApplicationController
  

  def index
    @lists_of_gems = ListOfGems.new(columns: 4)
  end
end
