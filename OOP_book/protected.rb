class Animal
  def a_public_method
    "Will this work? " + self.a_protected_method
  end

  protected

  def a_protected_method
    "Yes, I'm protected!"
  end
end

pixel = Animal.new
p pixel.a_public_method   # => "Will this work? Yes, I'm protected!"

p pixel.a_protected_method
# => NoMethodError: protected method 'a_protected_method' called for Animal