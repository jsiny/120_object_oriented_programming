module Swimmable
  OCEANS = %w(Pacific Atlantic Indian Arctic)

  def swim
    puts "just keep swimmin'"
  end
end

class Animal
  def initialize(name)
    @name = name
  end

  def sleep
    puts "zzzzzz"
  end
end

class Fish < Animal
  include Swimmable

  def swim
    super
    puts "I prefer the #{Swimmable::OCEANS.first} ocean"
  end

  def to_s
    "I'm a fish called #{name}"
  end

  private

  def name
    @name
  end
end

class Cat < Animal
  include Comparable

  def initialize(name, color, age)
    super(name)
    @color = color
    @age = age
  end

  def <=>(other)
    age <=> other.age
  end

  protected

  attr_reader :age
end

class Otter < Animal
  include Swimmable
end

pixel = Cat.new('pixel', 'black and white', 4)
lily = Cat.new('lily', 'tabby', 5)

p lily > pixel


Otter.new('cutie').swim
nemo = Fish.new('nemo')
puts nemo


module PokerGame
  class Deck; end
  class Cards; end
  class Dealer; end
  class Player; end
end

module Prisoners
  class Dealer; end
end

PokerGame::Dealer.new

p 4 + 5 # String#+
p 1.45 + 8.789 # Float#+
p [1, 2, 3] + [true] # Array#+
p "hello " + "world"   # String#+
