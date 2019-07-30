class Parent
  def say_hi
    p "Hi from Parent."
  end
end

class Child < Parent
  def say_hi
    p "Hi from Child."
  end
end

p Parent.superclass     # => Object
son = Child.new
son.send :say_hi        # => "Hi from Child."
