class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

hello = Hello.new
hello.hi
# => "Hello"

hello.bye
# => NoMethodError (undefined method "bye" for Hello object)

hello.greet
# => ArgumentError (given 0, expected 1)

hello.greet("Goodbye")
# => "Goodbye"

Hello.hi
# => NoMethodError (undefined method "hi" for Hello:class)
