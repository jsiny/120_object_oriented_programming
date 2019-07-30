class Parent
  def say_hi
    p "Hi from Parent."
  end
end

class Child < Parent
  def say_hi
    p "Hi from Child."
  end

  def send
    p "send from Child..."
  end

  def instance_of?
    p "I'm a fake instance"
  end
end

lad = Child.new
# lad.send :say_hi
# ArgumentError: wrong number of arguments (given 1, expected 0)

c = Child.new
p c.instance_of? Child    # true
p c.instance_of? Parent   # false
