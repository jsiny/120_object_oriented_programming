# require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # colons
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    @center = 5
    reset
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.select { |_, sq| sq.unmarked? }.keys
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  # returns winning marker or returns nil
  def winning_marker
    WINNING_LINES.each do |line|
      markers = get_markers_at(line)
      [Game::HUMAN_MARKER, Game::COMPUTER_MARKER].each do |marker|
        return marker if markers.count(marker) == 3
      end
    end
    nil
  end

  def get_markers_at(line)
    @squares.values_at(*line).map(&:marker)
  end

  def best_move
    line = find_strategic_square(Game::COMPUTER_MARKER)
    line ||= find_strategic_square(Game::HUMAN_MARKER)
    line ||= [@center]
    line.nil? ? nil : (unmarked_keys & line).first
  end

  private

  def find_strategic_square(player_marker)
    WINNING_LINES.each do |line|
      markers = get_markers_at(line)
      return line if identical_markers?(2, markers, player_marker)
    end
    nil
  end

  def identical_markers?(number, markers, player_marker)
    markers.delete(Square::INITIAL_MARKER)
    markers.uniq == [player_marker] && markers.size == number
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize
    @marker = INITIAL_MARKER
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :score, :name

  def initialize(marker, name)
    @marker = marker
    @score = 0
    @name = name
  end

  def add_point
    @score += 1
  end
end

class Human < Player
  def initialize
    super(Game::HUMAN_MARKER, "Juliette")
  end
end

class Computer < Player
  def initialize
    super(Game::COMPUTER_MARKER, "Wall-E")
  end
end

class Game
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_MOVE = HUMAN_MARKER
  NUMBER_OF_WINS = 2

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @current_player = FIRST_MOVE
  end

  def play
    display_welcome_message

    loop do
      display_board
      players_moves
      record_score
      display_result

      if grand_winner?
        display_grand_winner
        break
      end

      break unless play_again?

      reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def players_moves
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def human_turn?
    @current_player == human.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_player = computer.marker
    else
      computer_moves
      @current_player = human.marker
    end
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = ''
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board[square] = human.marker
  end

  def computer_moves
    move = board.best_move
    move ||= board.unmarked_keys.sample
    board[move] = computer.marker
  end

  def joinor(array, separator = ', ', word = 'or')
    return array.join(" #{word} ") if array.size < 3
    array[0...-1].join(separator) + "#{separator + word} #{array[-1]}"
  end

  def record_score
    case board.winning_marker
    when human.marker     then human.add_point
    when computer.marker  then computer.add_point
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker then puts 'You won!'
    when computer.marker then puts 'Computer won!'
    else puts "It's a tie!"
    end

    display_score
  end

  def display_score
    puts ""
    puts "SCORE:"
    puts "Player: #{human.score} - Computer: #{computer.score}"
    puts ""
  end

  def grand_winner?
    return human.name if human.score >= NUMBER_OF_WINS
    return computer.name if computer.score >= NUMBER_OF_WINS
    nil
  end

  def display_grand_winner
    puts "#{grand_winner?} is the Grand Winner!"
  end

  def play_again?
    answer = ''
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %(y n).include? answer
      puts "Sorry, must be y or n"
    end
    answer == 'y'
  end

  def display_welcome_message
    clear
    puts 'Welcome to Tic Tac toe!'
    puts "The first player who reaches #{NUMBER_OF_WINS} wins becomes the "\
      "Grand winner"
    puts ''
  end

  def display_goodbye_message
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    puts "You're #{human.marker}. Computer is #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def reset
    board.reset
    @current_player = FIRST_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ''
  end

  def clear
    system('clear')
  end
end

Game.new.play
