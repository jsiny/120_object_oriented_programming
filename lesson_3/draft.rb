class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def ==(other_cat)
    @name == other_cat.name
  end
end

kitty = Cat.new("teacup")
kitten = Cat.new("teacup")

p kitty == kitten # => true