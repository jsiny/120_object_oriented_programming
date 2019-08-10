# Version with various sizes of grid

require 'pry'

module Syntax
  def joinor(array, word = ' or ')
    return array.join(word.to_s) if array.size < 3
    array[0...-1].join(', ') + word.to_s + array[-1].to_s
  end
end

class Board
  attr_reader :size, :winning_lines

  POSSIBLE_GRID_SIZES = [3, 5, 7]

  def initialize(size)
    @size = size
    @center = size**2 / 2 + 1
    @squares = {}
    reset
    set_winning_lines
  end

  def draw
    case size
    when 3 then draw_size_3
    when 5 then draw_size_5
    end
  end

  def set_winning_lines
    @winning_lines = []
    set_winning_rows
    set_winning_columns
    set_winning_diagonals
  end

  def set_winning_rows
    @winning_lines += (1..size**2).to_a.each_slice(size).to_a
  end

  def set_winning_columns
    array = []
    (1..size).each do |n|
      n.step(by: size, to: size**2) { |i| array << i }
    end
    @winning_lines += array.each_slice(size).to_a
  end

  def set_winning_diagonals
    ary1 = size.step(size**2, size - 1).to_a[0...-1]
    ary2 = 1.step(size**2, size + 1).to_a
    @winning_lines += [ary1] + [ary2]
  end

  # rubocop:disable Metrics/AbcSize
  def draw_size_3
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

  def draw_size_5
    puts "     |     |     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}  |  #{@squares[4]}  |  #{@squares[5]}"
    puts "     |     |     |     |"
    puts "-----+-----+-----+-----+-----"
    puts "     |     |     |     |"
    puts "  #{@squares[6]}  |  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}  |  #{@squares[10]}"
    puts "     |     |     |     |"
    puts "-----+-----+-----+-----+-----"
    puts "     |     |     |     |"
    puts "  #{@squares[11]}  |  #{@squares[12]}  |  #{@squares[13]}  |  #{@squares[14]}  |  #{@squares[15]}"
    puts "     |     |     |     |"
    puts "-----+-----+-----+-----+-----"
    puts "     |     |     |     |"
    puts "  #{@squares[16]}  |  #{@squares[17]}  |  #{@squares[18]}  |  #{@squares[19]}  |  #{@squares[20]}"
    puts "     |     |     |     |"
    puts "-----+-----+-----+-----+-----"
    puts "     |     |     |     |"
    puts "  #{@squares[21]}  |  #{@squares[22]}  |  #{@squares[23]}  |  #{@squares[24]}  |  #{@squares[25]}"
    puts "     |     |     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def reset
    (1..size**2).each { |key| @squares[key] = Square.new }
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

  def winning_marker
    winning_lines.each do |line|
      markers = get_markers_at(line)
      [Game::MARKER_1, Game::MARKER_2].each do |marker|
        return marker if markers.count(marker) == 3
      end
    end
    nil
  end

  def get_markers_at(line)
    @squares.values_at(*line).map(&:marker)
  end

  def find_strategic_square(marker)
    winning_lines.each do |line|
      markers = get_markers_at(line)
      return line & unmarked_keys if identical_markers?(2, markers, marker)
    end
    nil
  end

  def place_center_square
    [@center] if unmarked_keys.include?(@center)
  end

  private

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
  attr_reader :score, :name
  attr_accessor :marker

  def initialize
    @marker = nil
    @score = 0
    @name = nil
  end

  def add_point
    @score += 1
  end
end

class Human < Player
  include Syntax

  def choose_name
    name = ''
    loop do
      puts "What's your name?"
      name = gets.chomp.delete('^a-zA-Z ').strip.capitalize
      break unless name.empty?
      puts "Sorry, you must enter a valid name"
    end
    @name = name
  end

  def choose_marker
    puts ''
    choice = ''
    markers = [Game::MARKER_1, Game::MARKER_2]
    loop do
      puts "Do you want to play with a marker '#{joinor(markers, "' or '")}'?"
      choice = gets.chomp.upcase
      break if markers.include?(choice)
      puts "Sorry, you must type '#{joinor(markers, "' or '")}'"
    end
    @marker = choice
  end

  def choose_first_move
    puts ''
    answer = ''
    loop do
      puts "Who should start the game: (y)ou or the (c)omputer?"
      answer = gets.chomp.downcase
      break if %w(y c).include?(answer)
      puts "Sorry, you must type 'y' for you or 'c' for computer"
    end
    answer
  end

  def choose_grid_size
    puts ''
    size = ''
    loop do
      puts "Which grid size do you want: #{joinor(Board::POSSIBLE_GRID_SIZES)}?"
      size = gets.chomp.to_i
      break if Board::POSSIBLE_GRID_SIZES.include?(size)
      puts "Sorry, you must type #{joinor(Board::POSSIBLE_GRID_SIZES)}"
    end
    size
  end
end

class Computer < Player
  def choose_name
    @name = %w(Wall-E HAL9000 Bender Terminator R2D2 AVA Baymax).sample
  end
end

class Game
  include Syntax

  MARKER_1 = 'X'
  MARKER_2 = 'O'
  NUMBER_OF_WINS = 2

  attr_reader :board, :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
    @first_move = :choose # choices: :choose, :computer, :human
    @current_marker = ''
  end

  def play
    display_welcome_message
    setup_game
    match_loop
    display_goodbye_message
  end

  private

  def play_round
    display_board
    players_moves
    record_score
    display_result
  end

  def match_loop
    loop do
      play_round

      if grand_winner?
        display_grand_winner
        break
      end

      break unless play_again?

      reset
      display_play_again_message
    end
  end

  def setup_game
    set_names
    set_first_move
    set_board
    set_markers
    set_current_marker
  end

  def set_names
    human.choose_name
    computer.choose_name
  end

  def set_first_move
    return @first_move unless @first_move == :choose
    answer = human.choose_first_move
    @first_move = case answer
                  when 'y' then :human
                  when 'c' then :computer
                  end
  end

  def set_board
    size = human.choose_grid_size
    @board = Board.new(size)
  end

  def set_markers
    human.choose_marker
    computer.marker = (human.marker == MARKER_1 ? MARKER_2 : MARKER_1)
  end

  def set_current_marker
    @current_marker = case @first_move
                      when :human    then human.marker
                      when :computer then computer.marker
                      end
  end

  def players_moves
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
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
    best_moves = board.find_strategic_square(computer.marker)  ||
                 board.find_strategic_square(human.marker)     ||
                 board.place_center_square                     ||
                 board.unmarked_keys

    move = best_moves.sample
    board[move] = computer.marker
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
    when human.marker     then puts "#{human.name} has won!"
    when computer.marker  then puts "#{computer.name} has won!"
    else puts "It's a tie!"
    end

    display_score
  end

  def display_score
    puts ""
    puts "SCORE:"
    puts "#{human.name}: #{human.score} - #{computer.name}: #{computer.score}"
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
    puts "You're #{human.marker}. #{computer.name} is #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def reset
    board.reset
    set_current_marker
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
