class GoodDog
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} says arf!"
  end
end

sparky = GoodDog.new("Sparky")
puts sparky.speak
# => Sparky says arf!

fido = GoodDog.new("Fido")
puts fido.speak
# => Fido says arf!

puts sparky.name    # => Sparky
sparky.name = "Spartacus"
puts sparky.name    # => Spartacus
