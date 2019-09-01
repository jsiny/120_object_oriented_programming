class GuessingGame
  attr_accessor :remaining_guesses

  MAX_GUESSES = 7
  RANGE = 1..100

  def initialize
    @remaining_guesses = MAX_GUESSES
    @number = rand(RANGE)
    @guess = nil
  end

  def play
    loop do
      display_remaining_guesses
      @guess = choose_number
      compare_numbers
      break if remaining_guesses <= 0 || number_found?
    end
    display_winner
    reset
  end

  private

  def display_remaining_guesses
    puts "You have #{remaining_guesses} guesses remaining."
  end

  def reset
    @number = rand(RANGE)
    @remaining_guesses = MAX_GUESSES
  end

  def choose_number
    guess = nil
    loop do
      print "Enter a number between #{RANGE.first} and #{RANGE.last}: "
      guess = gets.chomp.to_i
      break if RANGE.cover?(guess)

      print "Invalid guess. "
    end
    @remaining_guesses -= 1
    guess
  end

  def compare_numbers
    puts "Your guess is too high." if @guess > @number
    puts "Your guess is too low."  if @guess < @number
    puts "That's the number!"      if @guess == @number
    puts
  end

  def number_found?
    @guess == @number
  end

  def display_winner
    puts number_found? ? "You won!" : "You have no more guesses. You lost!"
    puts
  end
end

game = GuessingGame.new
game.play
game.play
