class MinilangError     < StandardError; end
class EmptyStackError   < MinilangError; end
class InvalidTokenError < MinilangError; end

class Minilang
  ACTIONS = %w(PRINT PUSH MULT ADD POP DIV MOD SUB)

  def initialize(program)
    @program = program
    @register = 0
    @stack = []
  end

  def eval
    @program.split.each { |element| eval_command(element) }
  rescue MinilangError => error
    puts error.message
  end

  def eval_command(element)
    if ACTIONS.include?(element)
      send(element.downcase)
    elsif element.to_i.to_s == element
      @register = element.to_i
    else
      raise InvalidTokenError, "Invalid token: #{element}"
    end
  end

  def print
    puts @register
  end

  def push
    @stack << @register
  end

  def mult
    @register *= @stack.pop
  end

  def add
    @register += @stack.pop
  end

  def pop
    raise EmptyStackError, "Empty stack!" if @stack.empty?
    @register = @stack.pop
  end

  def div
    @register /= @stack.pop
  end

  def mod
    @register %= @stack.pop
  end

  def sub
    @register -= @stack.pop
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

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)
