class Machine
  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def status
    puts "The machine is currently turned #{switch}"
  end

  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

c = Machine.new
c.start
c.status # => The machine is currently turned on

c.stop
c.status # => The machine is currently turned off
