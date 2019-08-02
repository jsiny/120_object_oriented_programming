class Move
  VALUES = %w(rock paper scissors)

  def initialize(value)
    @value = value
  end

  def >(other_move)
    scissors? && other_move.paper? ||
      paper?  && other_move.rock?  ||
      rock?   && other_move.scissors?
  end

  def to_s
    @value
  end

  protected

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end

  def to_s
    name
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.strip.empty?
      puts "Sorry, must enter a value"
    end
    self.name = n.strip
  end

  def choose
    choice = nil
    loop do
      puts 'Please choose (r)ock, (p)aper, or (s)cissors:'
      choice = convert(gets.chomp.downcase)
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice: you must type 'r', 'p' or 's'."
    end
    self.move = Move.new(choice)
  end

  private

  def convert(choice)
    case choice
    when 'r' then 'rock'
    when 'p' then 'paper'
    when 's' then 'scissors'
    end
  end
end

class Computer < Player
  def set_name
    self.name = %w(R2D2 Hal9000 Wall-e Baymax Bender Terminator AVA).sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Game
  attr_accessor :human, :computer

  POINTS_TO_WIN = 2
  SEPARATOR = "-----------------------------------"

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message
    loop do
      loop do
        human.choose
        computer.choose
        display_moves
        player_wins
        display_scores
        break if grand_winner?
      end
      break unless play_again?
      new_game
    end
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors"
    puts "You'll need to win #{POINTS_TO_WIN} rounds to become the "\
      "Grand Winner!"
    puts SEPARATOR
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def display_moves
    puts "#{human} chose #{human.move}."
    puts "#{computer} chose #{computer.move}."
  end

  def player_wins
    winner = find_winner
    if winner == :tie
      puts "It's a tie!"
    else
      puts "#{winner} won!"
      winner.score += 1
    end
  end

  def find_winner
    if human.move > computer.move
      human
    elsif computer.move > human.move
      computer
    else
      :tie
    end
  end

  def display_scores
    puts "SCORE: "\
      "#{human}: #{human.score} pt - "\
      "#{computer}: #{computer.score} pt"
    puts SEPARATOR
  end

  def grand_winner?
    if human.score > POINTS_TO_WIN
      puts "#{human} is the grand winner!"
    elsif computer.score > POINTS_TO_WIN
      puts "#{computer} is the grand winner!"
    else
      return false
    end
    true
  end

  def play_again?
    answer = nil

    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts "Sorry, must be 'y' or 'n'."
    end

    answer.downcase == 'y' ? true : false
  end

  def new_game
    puts SEPARATOR
    puts "NEW GAME!"
    human.score = 0
    computer.score = 0
  end
end

Game.new.play
