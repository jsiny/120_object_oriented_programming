class GuessingGame
  MAX_GUESSES   = 7
  RANGE         = (1..100)
  SLEEPING_TIME = 3
  RESULT_OF_COMPARISON = {  high: 'Your guess is too high.',
                            low: 'Your guess is too low.',
                            equal: "That's the number!" }

  def play
    reset_game
    game_round
    result
  end

  private

  def reset_game
    system 'clear'
    @number            = RANGE.to_a.sample
    @guesses_remaining = MAX_GUESSES
    @guess             = 0
    @result            = nil
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
      print "Enter a number between #{RANGE.first} and #{RANGE.last}: "
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
    RANGE.cover?(num)
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

game = GuessingGame.new
game.play
