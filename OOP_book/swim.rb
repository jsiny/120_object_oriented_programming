module Swimmable
  def swim
    "I'm swimming!"
  end
end

class Animal; end

class Fish < Animal
  include Swimmable   # mixing in Swimmable module
end

class Mammal < Animal
end

class Cat < Mammal
end

class Dog < Mammal
  include Swimmable   # mixing in Swimmable module
end

priska = Dog.new
pixel = Cat.new
nemo = Fish.new

p priska.swim   # => I'm swimming!
p nemo.swim     # => I'm swimming!
p pixel.swim    # => Undefined method 'swim' for Cat
