class WebsocketResultWrapper
  attr_accessor :action, :model, :now

  def initialize( action, model )
    self.action = action
    self.model = model
    # server time
    self.now = DateTime.current
  end

end
