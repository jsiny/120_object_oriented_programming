class Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class BadDog < Animal
  def initialize(age, name)
    super(name)
    @age = age
  end
end

harold = BadDog.new(2, "harold")
# => #<BadDog:0x0000000001a01fa8 @name="harold", @age=2>

class GoodDog < Animal
  def initialize(color)
    super
    @color = color
  end
end

bruno = GoodDog.new("brown")
# => #<GoodDog:0x00000000021b6758 @name="brown", @color="brown">
