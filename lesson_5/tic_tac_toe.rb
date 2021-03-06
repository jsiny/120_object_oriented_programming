# Module dedicated to making English sentences more 'fluid'
module Syntax
  def joinor(array, word = ' or ')
    return array.join(word.to_s) if array.size < 3
    array[0...-1].join(', ') + word.to_s + array[-1].to_s
  end
end

# Class that tracks all states of the playing board
class Board
  include Syntax

  attr_reader :size, :winning_lines

  POSSIBLE_GRID_SIZES = [3, 5, 7, 9]
  WIDTH = 5

  def initialize(size)
    @size = size
    @center = size**2 / 2 + 1
    @squares = {}
    reset
    set_winning_lines
  end

  def draw
    @squares_copy = @squares.values
    draw_squares
    (size - 1).times do
      draw_line('-', '+')
      draw_squares
    end
  end

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

  def unwinnable?
    winning_lines.each do |line|
      if (get_markers_at(line).uniq - [Square::INITIAL_MARKER]).size <= 1
        return false
      end
    end
    true
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    winning_lines.each do |line|
      markers = get_markers_at(line)
      [Game::MARKER_1, Game::MARKER_2].each do |marker|
        return marker if markers.count(marker) == size
      end
    end
    nil
  end

  def find_strategic_square(player_marker)
    winning_lines.each do |line|
      markers = get_markers_at(line)
      if identical_markers?(size - 1, markers, player_marker)
        return line & unmarked_keys
      end
    end
    nil
  end

  def place_center_square
    [@center] if unmarked_keys.include?(@center)
  end

  def display_available_squares
    size.times do |i|
      line = unmarked_keys.select do |n|
        n != size * i && n / size == i || n == size * (i + 1)
      end
      puts "- #{joinor(line)}" unless line.empty?
    end
  end

  private

  def draw_squares
    draw_line(' ', '|')
    draw_square_line
    draw_line(' ', '|')
  end

  def draw_line(space, separator)
    puts((space * WIDTH + separator) * (size - 1) + space * WIDTH)
  end

  def draw_square_line
    margin = ' ' * (WIDTH / 2)
    (size - 1).times do
      print margin + @squares_copy.shift.marker + margin + '|'
    end
    puts margin + @squares_copy.shift.marker
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

  def get_markers_at(line)
    @squares.values_at(*line).map(&:marker)
  end

  def identical_markers?(number, markers, player_marker)
    markers.delete(Square::INITIAL_MARKER)
    markers.uniq == [player_marker] && markers.size == number
  end
end

# The squares within the board
class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize
    @marker = INITIAL_MARKER
  end

  def to_s
    marker.to_s
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

# Player class, mostly dedicated to keeping track of the scores
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

# Human class, with various choices for the player
class Human < Player
  include Syntax

  def choose_name
    name = ''
    loop do
      puts "What's your name?"
      name = gets.chomp.delete('^a-zA-Z ').strip.capitalize
      break unless name.empty?
      puts 'Sorry, you must enter a valid name'
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
      puts 'Who should start the game: (y)ou or the (c)omputer?'
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

  def choose_move(board)
    puts 'Choose a square: '
    board.display_available_squares
    square = ''
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end
    board[square] = marker
  end
end

# Computer class, for the computer name and move logic
class Computer < Player
  def choose_name
    @name = %w(Wall-E HAL9000 Bender Terminator R2D2 AVA Baymax).sample
  end

  def choose_move(board, opponent_marker)
    best_moves = board.find_strategic_square(marker)          ||
                 board.find_strategic_square(opponent_marker) ||
                 board.place_center_square                    ||
                 board.unmarked_keys
    board[best_moves.sample] = marker
  end
end

# Game loop and mechanisms
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
    players_move
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

  def players_move
    loop do
      current_player_move
      break if board.someone_won? || board.full? || board.unwinnable?
      clear_screen_and_display_board if human_turn?
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  def current_player_move
    if human_turn?
      human.choose_move(board)
      @current_marker = computer.marker
    else
      computer.choose_move(board, human.marker)
      @current_marker = human.marker
    end
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
    else display_tie_result
    end

    display_score
  end

  def display_tie_result
    puts "Game interrupted: it's now impossible to win!" unless board.full?
    puts "It's a tie!"
  end

  def display_score
    puts ''
    puts 'SCORE:'
    puts "#{human.name}: #{human.score} - #{computer.name}: #{computer.score}"
    puts ''
  end

  def grand_winner?
    return human.name     if human.score    >= NUMBER_OF_WINS
    return computer.name  if computer.score >= NUMBER_OF_WINS
    nil
  end

  def display_grand_winner
    puts "#{grand_winner?} is the Grand Winner!"
  end

  def play_again?
    answer = ''
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if %(y n).include? answer
      puts 'Sorry, must be y or n'
    end
    answer == 'y'
  end

  def display_welcome_message
    clear
    puts 'Welcome to Tic Tac toe!'
    puts "The first player who reaches #{NUMBER_OF_WINS} wins becomes the "\
      'Grand winner'
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
    puts "You must align #{board.size} markers."
    puts ''
    board.draw
    puts ''
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
