class Cat
  # attr_accessor :name
  attr_writer :name
  attr_accessor :color

  @@total_number = 0

  def initialize(name, color)
    @name = name
    @color = color
    @@total_number += 1
  end

  def only_cat?
    @@total_number == 1
  end

  def name
    @name.upcase
  end

  def self.total_number
    @@total_number
  end

  def purr
    puts "prrrrr"
  end

  def to_s
    "My name is #{name} and I'm a #{color} cat"
  end

  def self.purr
    puts "The cat is purring"
  end
end

p Cat.total_number

pixel = Cat.new("Pixel", "black and white")
pixel.purr
puts pixel

p pixel.only_cat?

lily = Cat.new("lily", "tabby")
lily.purr
puts lily

lily.name = 'Elliot'
puts lily.name

p lily.only_cat?

Cat.purr
p Cat.total_number
