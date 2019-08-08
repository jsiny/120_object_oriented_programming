class Fruit
  def initialize(name)
    name = name
  end

  def something
    @something = 1
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# The class with an instance variable is Pizza, and I know
# because its variable starts with an @.

# I can also checkby creating Pizza and Fruit objects
# and calling the method instance_variables on them

p Pizza.new("cheese").instance_variables  # => [:@name]

peach = Fruit.new("peach")
p peach.instance_variables   # => []
peach.something
p peach.instance_variables   # => [:@something]
