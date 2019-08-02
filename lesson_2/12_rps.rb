class Move
  attr_reader :value

  WINNING_MOVES = { 'rock'      => %w(scissors lizard),
                    'scissors'  => %w(paper lizard),
                    'paper'     => %w(rock spock),
                    'spock'     => %w(scissors rock),
                    'lizard'    => %w(paper spock) }

  LOSING_MOVES = {  'rock'      => %w(spock paper),
                    'scissors'  => %w(spock rock),
                    'paper'     => %w(lizard scissors),
                    'spock'     => %w(lizard paper),
                    'lizard'    => %w(rock scissors) }

  def initialize(value)
    @value = value
  end

  def >(other_move)
    WINNING_MOVES[value].include?(other_move.value)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score, :history

  def initialize
    set_name
    @score = 0
    @history = Hash.new(0)
  end

  def to_s
    name
  end

  def display_history
    puts "#{name} has chosen:"
    @history.each { |choice, nb| puts "- #{choice.capitalize} #{nb} times" }
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp.delete('^a-zA-Z ').strip
      break unless n.empty?
      puts "Sorry, you must enter your name"
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts 'Please choose (r)ock, (p)aper, (s)cissors, (l)izard or (sp)ock:'
      choice = convert(gets.chomp.downcase)
      break if Move::WINNING_MOVES.keys.include?(choice)
      puts "Sorry, invalid choice: you must type 'r', 'p', 's' 'l' or 'sp'."
    end
    self.move = Move.new(choice)
    @history[choice] += 1
  end

  private

  def convert(choice)
    case choice
    when 'r'  then 'rock'
    when 'p'  then 'paper'
    when 's'  then 'scissors'
    when 'sp' then 'spock'
    when 'l'  then 'lizard'
    end
  end
end

class Computer < Player
  START_ANALYZING_HISTORY = 3

  def set_name
    self.name = %w(R2D2 Hal9000 Wall-e Baymax Bender Terminator AVA).sample
  end

  def choose(opponent_history)
    choice = if history.values.sum < START_ANALYZING_HISTORY
               Move::WINNING_MOVES.keys.sample
             else
               select_winner(opponent_history)
             end

    self.move = Move.new(choice)
    @history[choice] += 1
  end

  private

  def find_favorite(opponent_history)
    opponent_history.key(opponent_history.values.max)
  end

  def select_winner(opponent_history)
    favorite = find_favorite(opponent_history)
    Move::LOSING_MOVES[favorite].sample
  end
end

class Game
  attr_accessor :human, :computer

  POINTS_TO_WIN = 3
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
        computer.choose(human.history)
        display_moves
        player_wins
        display_scores
        break if grand_winner?
        display_histories
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

  def display_histories
    sleep 2
    puts "HISTORY:"
    human.display_history
    computer.display_history
    puts SEPARATOR
  end

  def grand_winner?
    if human.score >= POINTS_TO_WIN
      puts "#{human} is the Grand Winner!"
    elsif computer.score >= POINTS_TO_WIN
      puts "#{computer} is the Grand Winner!"
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
