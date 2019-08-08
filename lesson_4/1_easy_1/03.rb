module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

small_car = Car.new
puts small_car.go_fast
# => I am a Car going super fast!

# The string printed includes the class name.
# This is possible because the string calls the self
# (here: Car) and its class
# We don't need to add to_s here becaue it's inside a 
# string interpolation
