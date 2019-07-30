class Student
  attr_accessor :name
  attr_writer :grade

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(student)
    grade > student.grade
  end

  protected

  def grade
    @grade
  end
end

joe = Student.new("Joe", 15)
# p joe.grade

chad = Student.new("Chad", 11)

puts "Well done!" if joe.better_grade_than?(chad)
