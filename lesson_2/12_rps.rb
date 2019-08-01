class Player
  def initialize
    # name?
  end

  def choose
    # returns a move
  end
end

class Move
  def initialize
    # a move object can be paper rock or scissors
  end
end

class Rule
  def initialize
    # unsure about the 'state' of a rule object
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new
  end

  def play
    display_welcome_message
    human.choose
    computer.choose
    display_winner
    display_goodbye_message
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end
end

def compare(move1, move2)
end

RPSGame.new.play
