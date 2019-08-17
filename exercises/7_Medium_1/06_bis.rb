module GameSettings
  RANGE = (1..100)

  def valid_number?(num)
    RANGE.cover?(num)
  end
end

class GuessingGame
  include GameSettings

  attr_reader :player

  MAX_GUESSES          = 7
  RESULT_OF_COMPARISON = { high: 'Your guess is too high.',
                           low: 'Your guess is too low.',
                           equal: "That's the number!" }
  def initialize
    @player            = Player.new
    @number            = nil
    @guesses_remaining = nil
    @result            = nil
    system 'clear'
    display_welcome_message
  end

  def play
    reset_game
    game_round
    result
  end

  private

  def reset_game
    @number            = RANGE.to_a.sample
    @guesses_remaining = MAX_GUESSES
    @result            = nil
  end

  def game_round
    loop do
      display_remaining_guesses
      player.guess_number
      display_comparison_result
      break if no_more_guesses? || number_found?
    end
  end

  def display_welcome_message
    puts 'Welcome to the Guessing Game!'
    puts "Your goal: to find the secret number,"
    puts "that lies between #{RANGE.first} and #{RANGE.last}."
    puts ''
  end

  def display_remaining_guesses
    print "You have #{@guesses_remaining} "
    puts @guesses_remaining == 1 ? 'guess remaining.' : 'guesses remaining.'
    @guesses_remaining -= 1
  end

  def display_comparison_result
    @result = compare_numbers
    puts RESULT_OF_COMPARISON[@result]
    puts ''
  end

  def compare_numbers
    return :high if player.guess > @number
    return :low  if player.guess < @number
    :equal
  end

  def number_found?
    @result == :equal
  end

  def no_more_guesses?
    @guesses_remaining <= 0
  end

  def result
    puts number_found? ? 'You won!' : 'You have no more guesses. You lost!'
  end
end

class Player
  include GameSettings

  attr_reader :guess

  def initialize
    @guess = nil
  end

  def guess_number
    @guess = choose_number
  end

  private

  def choose_number
    loop do
      print "Enter a number between #{RANGE.first} and #{RANGE.last}: "
      guess = gets.chomp.to_i
      return guess if valid_number?(guess)
      print "Invalid guess. "
    end
  end
end

game = GuessingGame.new
game.play
