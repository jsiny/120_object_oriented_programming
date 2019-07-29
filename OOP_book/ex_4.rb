# input

class Person
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
# bob.name = "Bob"

# output

# Undefined method `name=' for #<Person:0x000000000103a9c0 @name="Steve"> (NoMethodError)

# We get this error because we haven't defined a setter method `name=`.
# As we're using the `attr_reader`, only the getter method `name` has been defined.
# To solve this, we should change the line 4 to `attr_accessor`

class Person
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
p bob.name = "Bob"
