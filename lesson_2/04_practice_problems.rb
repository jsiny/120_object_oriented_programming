class Animal
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Animal
  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end

  def speak
    "bark!"
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

class Cat < Animal
  def speak
    'meow!'
  end
end

teddy = Dog.new
puts teddy.speak
puts teddy.swim

yoda = Bulldog.new
puts yoda.speak
puts yoda.swim

pixel = Cat.new
puts pixel.speak
puts pixel.jump

p Bulldog.ancestors