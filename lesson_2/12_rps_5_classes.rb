# Copy of the RPS assignment dedicated to the 5 subclasses of Move

class Move
  WINNING_MOVES = { 'Rock'      => %w(Scissors Lizard),
                    'Scissors'  => %w(Paper Lizard),
                    'Paper'     => %w(Rock Spock),
                    'Spock'     => %w(Scissors Rock),
                    'Lizard'    => %w(Paper Spock) }

  def >(other_move)
    WINNING_MOVES[self.class.to_s].include?(other_move.class.to_s)
  end

  def to_s
    self.class.to_s
  end
end

class Rock      < Move; end
class Paper     < Move; end
class Scissors  < Move; end
class Lizard    < Move; end
class Spock     < Move; end

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
      puts 'Please choose (r)ock, (p)aper, (s)cissors, (l)izard or (sp)ock:'
      choice = convert(gets.chomp.downcase)
      break if Move::WINNING_MOVES.include?(choice.to_s)
      puts "Sorry, invalid choice: you must type 'r', 'p', 's' 'l' or 'sp'."
    end
    self.move = choice.new
  end

  private

  def convert(choice)
    case choice
    when 'r'  then Rock
    when 'p'  then Paper
    when 's'  then Scissors
    when 'sp' then Spock
    when 'l'  then Lizard
    end
  end
end

class Computer < Player
  def set_name
    self.name = %w(R2D2 Hal9000 Wall-e Baymax Bender Terminator AVA).sample
  end

  def choose
    self.move = Object.const_get(Move::WINNING_MOVES.keys.sample).new
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
    puts "Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts "You'll need to win #{POINTS_TO_WIN} rounds to become the "\
      "Grand Winner!"
    puts SEPARATOR
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
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
