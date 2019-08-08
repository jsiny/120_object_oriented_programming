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

class Truck
  include Speed

  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

# We can check that our Car or Truck can go fast now by
# calling ancestors

p Car.ancestors
# => [Car, Speed, Object, Kernel, BasicObject]
p Truck.ancestors
# => [Truck, Speed, Object, Kernel, BasicObject]

puts Car.new.go_fast
# => I am a Car and going super fast!

puts Truck.new.go_fast
# => I am a Truck and going super fast!
