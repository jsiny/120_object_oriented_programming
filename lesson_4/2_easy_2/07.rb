class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# @@cats_count is a class variable, that is incremented by 1
# anytime an instance of the class Cat is initialized.

# We can also call the class method Cat.cats_count in order to 
# retrieve the @@cats_count value

# Here's proof:

p Cat.cats_count    # => 0
kitty = Cat.new("tabby")
kitten = Cat.new("white")
p Cat.cats_count    # => 2
