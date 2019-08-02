class Move
  VALUES = %w(rock paper scissors)

  def initialize(value)
    @value = value
  end

  def >(other_move)
    rock?        && other_move.scissors? ||
      paper?     && other_move.rock?     ||
      scissors?  && other_move.paper?
  end

  # def <(other_move)
  #   rock?       && other_move.paper?    ||
  #     paper?    && other_move.scissors? ||
  #     scissors? && other_move.rock?
  # end

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
    @score = Score.new
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

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      player_wins
      display_scores
      break unless play_again?
    end
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors"
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
      winner.score.add_point
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
      "#{human}: #{human.score.value} pt - "\
      "#{computer}: #{computer.score.value} pt"
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
end

class Score
  attr_accessor :value

  POINTS_TO_WIN = 3

  def initialize
    @value = 0
  end

  def add_point
    @value += 1
  end

  def win?
    value >= POINTS_TO_WIN
  end
end

RPSGame.new.play
