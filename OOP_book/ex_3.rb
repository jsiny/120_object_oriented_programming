class Vehicle

  attr_accessor :color
  attr_reader :year, :model

  @@number_of_vehicles = 0

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed =
    @@number_of_vehicles += 1
  end

  def self.mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  def self.number_of_vehicles
    @@number_of_vehicles
  end

  def speed_up(number)
    @current_speed += number
  end

  def brake(number)
    @current_speed -= number
  end

  def current_speed
    puts "You are now going at #{@current_speed} km per hour"
  end

  def shut_down
    @current_speed = 0
    puts "Let's park this bad boy!"
  end

  def spray_paint(color)
    self.color = color
  end

  def age
    "Your #{self.model} is #{years_old} years old."
  end

  private

  def years_old
    Time.now.year - self.year
  end

end

module Shoveling
  def shovel
    puts "I'm shoveling"
  end
end


# My Car class
class MyCar < Vehicle
  NUMBER_OF_DOORS = 2

  def to_s
    "My car is a #{color} #{model} from #{year}."
  end

end

class MyTruck < Vehicle
  SIZE_OF_WHEELS = 3

  include Shoveling

  def to_s
    "My truck is a #{color} #{model} from #{year}."
  end
end

twingo = MyCar.new(2014, 'white', 'Renault Twingo')

twingo.speed_up(30)
twingo.current_speed
twingo.brake(10)
twingo.current_speed
twingo.speed_up(20)
twingo.current_speed
twingo.shut_down

puts "My car is from #{twingo.year}"
puts "It's #{twingo.color}."
twingo.color = 'red'
puts "It's now #{twingo.color}."
twingo.spray_paint('blue')
puts "It's now #{twingo.color}."

MyCar.mileage(480, 7800)

puts twingo

truck = MyTruck.new(1999, 'red', 'Monster Truck')
puts truck
truck.shovel

puts Vehicle.number_of_vehicles

puts "---Vehicle ancestors:---"
puts Vehicle.ancestors

puts "---MyCar ancestors:---"
puts MyCar.ancestors

puts "---MyTruck ancestors:---"
puts MyTruck.ancestors

puts twingo.age
puts truck.age
