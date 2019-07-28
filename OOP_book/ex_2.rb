# A module is a collection of behaviors that can be used by other classes
# via mixins.

# A module is mixed in to a class using the `include` method invocation.

module Play
  def catch_mice
    puts "I'll catch ya!"
  end
end

class Cat
  include Play
end

pixel = Cat.new

pixel.catch_mice
