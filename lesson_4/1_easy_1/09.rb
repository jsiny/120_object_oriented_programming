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

# In self.cats_count, "self" refers to the class Cat 
# (it's a class method)

# You can therefore call Cat.cats_count
