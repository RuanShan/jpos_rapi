class SocketResult::Base
  attr_accessor :action, :now

  def initialize( )

    self.now = DateTime.current
  end

end
