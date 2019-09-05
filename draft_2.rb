module Hunter
  PREYS = %w(mice rodents)

  def hunt
    puts "I'm busy hunting preys"
  end
end

module Flight; end
module Speak; end

class Animal
  include Speak

  def initialize(legs)
    @legs = legs
  end

  def print_walking
    puts "I have #{legs} legs and I can run"
  end

  private

  attr_reader :legs
end

class Cat < Animal
  attr_reader :what_is_self

  include Hunter

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

class Bird < Animal
end

class Hawk < Bird
  include Flight
  include Hunter
end

kitty = Cat.new(4)
kitty.print_walking
kitty.hunt
p kitty.what_is_self
p Cat.what_is_self

bob = Human.new("bob", kitty)
p bob.pet
bob.pet.hunt

hawk = Hawk.new(2)
hawk.print_walking
hawk.hunt

p 3 + 4
p [3, 4] + [5]
p "hello " + "world"

module MechanicalObjects
  class Crane
  end
end

module Birds
  class Crane
  end
end

p MechanicalObjects::Crane.new
p Birds::Crane.new

p Hawk.ancestors

