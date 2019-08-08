class Cube
  attr_accessor :volume

  def initialize(volume)
    @volume = volume
  end
end

box = Cube.new(2)
p box.volume

# To make @volume accessible, we could:
# - call it with instance_variable_get("@volume")
# - use attr_accessor or attr_reader
# - add a getter method to the class
