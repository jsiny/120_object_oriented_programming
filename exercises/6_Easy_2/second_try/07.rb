class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def number_of_pets
    pets.size
  end

  def adopt(pet)
    pets << pet
  end

  def print_pets
    pets.each { |pet| puts pet }
  end
end

class Pet
  def initialize(animal, name)
    @animal = animal
    @name = name
  end

  def to_s
    "a #{@animal} named #{@name}"
  end

  def self.all_pets
    ObjectSpace.each_object(Pet).to_a
  end
end

class Shelter
  def initialize
    @owners = []
    @unadopted = Pet.all_pets
  end

  def adopt(owner, pet)
    owner.adopt(pet)
    @owners << owner
    @unadopted.delete(pet)
  end

  def print_unadopted
    puts "The Animal Shelter has the following unadopted pets:"
    @unadopted.each { |pet| puts pet }
    puts
  end

  def print_adoptions
    @owners.uniq.each do |owner|
      puts "#{owner.name} has adopted the following pets:"
      owner.print_pets
      puts
    end
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
pixel        = Pet.new('cat', 'Pixel')
priska       = Pet.new('dog', 'Priska')
claude       = Pet.new('cat', 'Claude')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')
jsiny   = Owner.new('J Siny')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.adopt(jsiny,   pixel)

shelter.print_unadopted
shelter.print_adoptions

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "#{jsiny.name} has #{jsiny.number_of_pets} adopted pets."

# P Hanson has adopted the following pets:
# a cat named Butterscotch
# a cat named Pudding
# a bearded dragon named Darwin

# B Holmes has adopted the following pets:
# a dog named Molly
# a parakeet named Sweetie Pie
# a dog named Kennedy
# a fish named Chester

# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.
