require 'pry'

class MinilangError   < StandardError; end
class EmptyStackError < MinilangError; end
class BadTokenError   < MinilangError; end

class Minilang
  OPERATIONS = { mult:  :*,
                 add:   :+,
                 div:   :/,
                 mod:   :%,
                 sub:   :- }

  ACTIONS = [:pop, :push, :print]

  def initialize(program)
    @program = program
    @register = 0
    @stack = []
  end

  def eval
    @program.split(' ').each do |el|
      integer?(el) ? @register = el.to_i : execute(el.downcase.to_sym)
    end
  end

  private

  def integer?(string)
    string.to_i.to_s == string
  end

  def execute(order)
    if OPERATIONS.keys.include?(order)
      @register = @register.send(OPERATIONS[order], @stack.pop)
    elsif ACTIONS.include?(order)
      send(order)
    else
      raise BadTokenError, "Invalid token"
    end
  end
  
  def print
    puts @register
  end

  def push
    @stack << @register
  end

  def pop
    @register = @stack.pop
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

# Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

# Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)
