module Walkable
  def walk
    "I'm walking."
  end
end

module Swimmable
  def swim
    "I'm swimming."
  end
end

module Climbable
  def climb
    "I'm climbing"
  end
end

class Animal
  include Walkable

  def speak
    "I'm an animal, and I speak!"
  end
end

puts "---Animal method lookup---"
puts Animal.ancestors

class Cat < Animal
  include Swimmable
  include Climbable
end

puts "---Cat method lookup---"
puts Cat.ancestors

pixel = Animal.new

puts pixel.speak
# => I'm an animal, and I speak!
# Ruby found the speak method in the Animal class and looked no further

puts pixel.walk
# => I'm walking.
# Ruby first looked for the walk instance method in Animal, and not finding it
# here, went on to look in the next place, the Walkable module. It found it here.

puts pixel.swim
# => NoMethodError: undefined method 'swim' for Animal
# Ruby traversed all the classes and modules in the lsit, and didn't find a
# 'swim' method.