class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def add_pet(pet)
    @pets << pet
  end

  def print_pets
    pets.each { |pet| puts pet }
  end

  def number_of_pets
    pets.size
  end
end

class Pet
  attr_reader :animal, :name

  def initialize(animal, name)
    @animal = animal
    @name = name
  end

  def to_s
    "a #{animal} named #{name}"
  end

  def self.all_pets
    ObjectSpace.each_object(self).entries
  end
end

class Shelter
  attr_reader :owners, :unadopted

  def initialize
    @owners = {}
    @adopted = []
  end

  def adopt(owner, pet)
    owner.add_pet(pet)
    @owners[owner.name] ||= owner
    @adopted << pet
  end

  def print_adoptions
    owners.each do |name, owner|
      puts "#{name} has adopted the following pets:"
      owner.print_pets
      puts " "
    end
  end

  def print_unadopted
    @unadopted = Pet.all_pets - @adopted
    puts "The Animal Shelter has the following unadopted pets:"
    @unadopted.each { |pet| puts pet }
    puts " "
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
asta         = Pet.new('dog', 'Asta')
laddie       = Pet.new('dog', 'Laddie')
fluffy       = Pet.new('cat', 'Fluffy')
kat          = Pet.new('cat', 'Kat')
ben          = Pet.new('cat', 'Ben')
chatterbox   = Pet.new('parakeet', 'Chatterbox')
bluebell     = Pet.new('parakeet', 'Bluebell')


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
shelter.print_adoptions
shelter.print_unadopted

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "#{jsiny.name} has #{jsiny.number_of_pets} adopted pets."
puts "The Animal Shelter has #{shelter.unadopted.size} unadopted pets."

