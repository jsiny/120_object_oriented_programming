class Cat
  attr_writer :name

  @@total_number = 0

  def initialize(name, color)
    @name = name
    @color = color
    @@total_number += 1
  end

  def purr
    "prrrrrrr"
  end

  def to_s
    "My name is #{name} and I'm a #{@color} cat."
  end

  def name
    @name.upcase
  end

  def self.total_number
    @@total_number
  end
end

p Cat.total_number

kitty = Cat.new('Lily', 'tabby')
puts kitty
p kitty.purr

p kitty.name = 'pixel'
puts kitty

p kitty.name

grumpy_cat = Cat.new('Grumpy', "white")
puts grumpy_cat
p grumpy_cat.purr

p Cat.total_number
