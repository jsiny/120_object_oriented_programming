class Computer1
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

class Computer2
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end

# The main difference between the two programs is the fact that we'
# referencing the instance variable @template in the first
# and working with the setter method template=() in the second

# In show template, the first program is not using self,
# which is a bit better than using it unnecessarily (like in
# the second program)
