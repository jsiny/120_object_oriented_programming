class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end

# In order to create a new instance of this class,
# we'd need to provide .new with 2 arguments:

handbag = Bag.new("blue", "leather")
puts handbag # => #<Bag:0x00007fffe4a03b38>
