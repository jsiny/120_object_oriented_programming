class Machine
  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def status
    puts "I'm #{switch}!"
  end

  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

radio = Machine.new
radio.start
radio.status
radio.stop
radio.status
