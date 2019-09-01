class GuessingGame
  attr_accessor :remaining_guesses

  def initialize(min, max)
    @range = min..max
    @remaining_guesses = compute_max_guesses
    @number = rand(@range)
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

  def compute_max_guesses
    Math.log2(@range.size).to_i + 1
  end

  def display_remaining_guesses
    puts "You have #{remaining_guesses} guesses remaining."
  end

  def reset
    @number = rand(@range)
    @remaining_guesses = compute_max_guesses
  end

  def choose_number
    guess = nil
    loop do
      print "Enter a number between #{@range.first} and #{@range.last}: "
      guess = gets.chomp.to_i
      break if @range.cover?(guess)

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

game = GuessingGame.new(501, 1500)
game.play
