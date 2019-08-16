class Student
  def initialize(name, year)
    @name = name
    @year = year
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    @parking = parking
    super(name, year)
  end
end

class Undergraduate < Student
end

Undergraduate.new("Steph", 2019)
Graduate.new("Stacy", 2016, true)
