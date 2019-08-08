class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

pixel = AngryCat.new(1, "pixel")
priska = AngryCat.new(0, "priska")

pixel.hiss
