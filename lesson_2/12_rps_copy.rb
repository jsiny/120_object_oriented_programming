class Player
  attr_accessor :move, :name

  def initialize(player_type = :human)
    @player_type = player_type
    @move = nil
    set_name
  end

  def set_name
    self.name = if human?
                  n = ''
                  loop do
                    puts "What's your name?"
                    n = gets.chomp
                    break unless n.empty?
                    puts "Sorry, must enter a value"
                  end
                  n
                else
                  %w(R2D2 Hal9000 Wall-e Baymax Bender Terminator AVA).sample
                end
  end

  def choose
    if human?
      choice = nil
      loop do
        puts 'Please choose rock, paper, or scissors:'
        choice = gets.chomp
        break if %w(rock paper scissors).include?(choice)
        puts 'Sorry, invalid choice.'
      end
      self.move = choice
    else
      self.move = %w(rock paper scissors).sample
    end
  end

  def human?
    @player_type == :human
  end
end

class RPSGame
  attr_accessor :human, :computer

  WINS_OVER = { 'rock'      => 'scissors',
                'scissors'  => 'paper',
                'paper'     => 'rock' }

  def initialize
    @human = Player.new
    @computer = Player.new(:computer)
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_choices
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def display_choices
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move == computer.move
      puts "It's a tie!"
    elsif WINS_OVER[human.move] == computer.move
      puts "#{human.name} has won!"
    else
      puts "#{computer.name} has won!"
    end
  end

  def play_again?
    answer = nil

    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if %w(y n).include? answer.downcase
      puts "Sorry, must be y or n."
    end

    answer == 'y' ? true : false
  end
end

RPSGame.new.play
