class GuessingGame
  attr_reader :range

  SLEEPING_TIME = 3
  RESULT_OF_COMPARISON = {  high: 'Your guess is too high.',
                            low: 'Your guess is too low.',
                            equal: "That's the number!" }

  def initialize(first, last)
    @number            = nil
    @guess             = nil
    @result            = nil
    @guesses_remaining = nil
    @range             = (first..last)
    system 'clear'
    display_welcome_message
  end

  def play
    reset_game
    game_round
    result
  end

  private

  def display_welcome_message
    puts 'Welcome to the Guessing Game!'
    puts "Your goal: to find the secret number,"
    puts "that lies between #{range.first} and #{range.last}."
    puts ''
  end

  def reset_game
    @number = rand(range)
    @guesses_remaining = Math.log2(range.size).to_i + 1
  end

  def game_round
    loop do
      display_remaining_guesses
      @guess = choose_number
      display_comparison_result
      break if no_more_guesses? || number_found?
    end
  end

  def display_remaining_guesses
    print "You have #{@guesses_remaining} "
    puts @guesses_remaining == 1 ? 'guess remaining.' : 'guesses remaining.'
    @guesses_remaining -= 1
  end

  def choose_number
    loop do
      print "Enter a number between #{range.first} and #{range.last}: "
      guess = gets.chomp.to_i
      return guess if valid_number?(guess)
      print "Invalid guess. "
    end
  end

  def display_comparison_result
    @result = compare_numbers
    puts RESULT_OF_COMPARISON[@result]
    puts ''
  end

  def compare_numbers
    return :high if @guess > @number
    return :low  if @guess < @number
    :equal
  end

  def valid_number?(num)
    range.cover?(num)
  end

  def number_found?
    @result == :equal
  end

  def no_more_guesses?
    @guesses_remaining <= 0
  end

  def result
    puts number_found? ? 'You won!' : 'You have no more guesses. You lost!'
    sleep SLEEPING_TIME
  end
end

game = GuessingGame.new(501, 1500)
game.play
game.play
