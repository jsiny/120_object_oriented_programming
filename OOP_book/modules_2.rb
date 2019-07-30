module Mammal
  class Dog
    def speak(sound)
      p "#{sound}"
    end
  end

  class Cat
    def say_name(name)
      p "#{name}"
    end
  end

  def self.some_out_of_place_method(num)
    num**2
  end
end

priska = Mammal::Dog.new
pixel = Mammal::Cat.new

priska.speak("Ouaf!")     # => "Ouaf!"
pixel.say_name("Pixel")   # => "Pixel"

value = Mammal.some_out_of_place_method(4)
value = Mammal::some_out_of_place_method(4)