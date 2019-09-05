module Herbivore
  def eat_grass
  end
end

module Suckle
  def feed_baby
  end
end

module Fur
  def grow_winter_coat
  end
end

class Animal
end

class Mammal < Animal
  include Suckle
  include Fur
end

class Giraffe < Mammal
  include Herbivore

  def what_is_self
    self
  end

  def self.what_is_self
    self
  end
end

class Human
  attr_reader :pet

  def initialize(name, pet)
    @name = name
    @pet = pet
  end
end

sophie = Giraffe.new
p Giraffe.ancestors

# [Giraffe, Herbivore, Mammal, Fur, Suckle, Animal, Object, Kernel, BasicObject]

p Giraffe.new.what_is_self # Giraffe object
p Giraffe.what_is_self     # Giraffe

bob = Human.new("Bob", sophie)
p bob.pet.what_is_self

