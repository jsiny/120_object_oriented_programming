class Animal
  def speak
    "Hello!"
  end
end

class Dog < Animal
  attr_accessor :name

  def initialize(n)
    self.name = n
  end

  def speak
    "#{self.name} says arf!"
  end

end

class Cat < Animal
end

priska = Dog.new("Priska")
pixel = Cat.new

puts priska.speak   # => Priska says arf!
puts pixel.speak    # => Hello!
