module Tools
  MAX_SIZE      = 40
  LINE_BREAK    = '-' * MAX_SIZE
  SMALL_BREAK   = '-' * 15
  SLEEPING_TIME = 1
  MAX_SCORE     = 21 # not sure this should be here

  def wrap_sentence(str, max_size = MAX_SIZE)
    words = str.split
    line_size = 0

    loop do
      word = words.shift
      line_size += word.size + 1

      if line_size > max_size
        word.prepend("\n")
        line_size = word.size + 1
      end

      print word + ' '
      break if words.empty?
    end
    print "\n"
  end

  def clear
    system 'clear' || system('cls')
  end

  def print_center(message)
    puts message.center(MAX_SIZE)
  end

  def numeric_string?(str)
    str.to_i.to_s == str
  end
end

class Player
  include Tools

  attr_accessor :hand, :deck
  attr_reader :exit_strategy

  def initialize(deck)
    @hand = []
    @deck = deck
    @exit_strategy = nil
  end

  def turn(table)
    loop do
      sleep SLEEPING_TIME
      clear
      table.display_cards_and_scores
      break if busted? || stayed?
      play
    end
  end

  def score
    @score = 0
    hand.each do |card|
      card_value = card.split.first
      @score += if numeric_string?(card_value)
                  card_value.to_i
                elsif Deck::HEADS.include?(card_value)
                  10
                else
                  11
                end
    end
    control_for_aces
    @score
  end

  def hit
    hand << deck.deal
  end

  def busted?
    @exit_strategy = :busted if @score > MAX_SCORE
  end

  def stayed?
    @exit_strategy == :stayed
  end

  def play
    case choose_action
    when 'h' then hit
    when 's' then stay
    end
  end

  private

  def stay
    @exit_strategy = :stayed
  end

  def control_for_aces
    hand.each do |card|
      @score -= 10 if card[0] == 'A' && @score > MAX_SCORE
    end
  end
end

class Gambler < Player
  VALID_PLAY_ANSWERS = %w(h s)
  # def initialize
  #   # What would be the states of a Gambler object? cards? a name?
  # end

  def play
    puts ''
    puts "It's your turn!"
    super
  end

  private

  def hit
    puts "You chose to hit! Let's see if that was wise..."
    super
  end

  def stay
    puts "You chose to stay. Better safe than sorry eh?"
    super
  end

  def choose_action
    answer = ''
    loop do
      puts 'Do you (h)it or (s)tay?'
      answer = gets.chomp.downcase
      break if VALID_PLAY_ANSWERS.include?(answer)
      puts "Sorry, you must type 'h' or 's'"
    end
    answer
  end
end

class Dealer < Player
  attr_reader :second_card

  def initialize(deck)
    super
    @second_card = :hidden
  end

  def public_hand
    second_card == :hidden ? hand.first : hand.join(' - ')
  end

  def score
    if second_card == :hidden
      '?'
    else
      super
    end
  end

  def play
    puts ''
    puts "It's now the dealer's turn!"
    super
  end

  def choose_action
    @score >= 17 ? 's' : 'h'
  end

  def reveal_hand
    @second_card = :revealed
  end

  def stay
    puts 'The dealer stays!'
    sleep SLEEPING_TIME
    super
  end

  def hit
    puts 'The dealer hits...'
    super
  end
end

class Deck
  attr_accessor :deck

  SUITS  = %w(♠ ♥ ♦ ♣)
  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  HEADS  = %w(J Q K)

  def initialize
    shuffle_deck
  end

  def shuffle_deck
    @deck = []
    SUITS.each do |suit|
      VALUES.each { |value| deck << value + ' ' + suit }
    end
    deck.shuffle!
  end

  def deal
    deck.shift
  end
end

class Table
  include Tools

  attr_reader :dealer, :gambler

  def initialize(dealer, gambler)
    @dealer = dealer
    @gambler = gambler
  end

  def display_cards_and_scores
    print_center("Your hand:")
    print_center(gambler.hand.join(' - '))
    puts ''
    print_center("Score: #{gambler.score}")
    print_center(SMALL_BREAK)
    print_center("Dealer's hand:")
    print_center(dealer.public_hand)
    puts ''
    print_center("Score: #{dealer.score}")
  end
end

class Game
  include Tools

  attr_reader :deck, :gambler, :dealer, :table

  def start
    display_welcome_message
    setup_game
    deal_cards
    players_turn
    show_result
  end

  private

  def display_welcome_message
    clear
    wrap_sentence(welcome_message)
    gets.chomp
    clear
  end

  def welcome_message
    <<~BLOCK
      Welcome to our Special Casino, where you can only play (some kind of)
      BlackJack!
      #{LINE_BREAK}
      Each card has a value: numbers are worth their face value, figures are
      worth 10 points, and an ace can be worth 1 or 10.
      Your goal: to get as close as possible to #{MAX_SCORE}, without going
      overboard!
      #{LINE_BREAK}
      Understood? Type any key to start the game!
    BLOCK
  end

  def setup_game
    @deck = Deck.new
    @dealer = Dealer.new(deck)
    @gambler = Gambler.new(deck)
    @table = Table.new(dealer, gambler)
  end

  def deal_cards
    print_center('Shuffling cards...')
    2.times do
      gambler.hand << deck.deal
      dealer.hand << deck.deal
    end
  end

  def players_turn
    gambler.turn(table)
    return unless dealer_can_play?
    dealer.reveal_hand
    dealer.turn(table)
  end

  def dealer_can_play?
    gambler.exit_strategy == :stayed
  end

  def show_result
    puts ''
    wrap_sentence(result_message)
  end

  def result_message
    if gambler.exit_strategy == :busted
      gambler_busts_message
    elsif dealer.exit_strategy == :busted
      dealer_busts_message
    else
      compare_scores
    end
  end

  def compare_scores
    if gambler.score > dealer.score
      gambler_wins_message
    elsif dealer.score > gambler.score
      dealer_wins_message
    else
      no_one_wins_message
    end
  end

  def gambler_busts_message
    <<~BLOCK
      You busted!! Told you, you shouldn't have pushed your luck!
      Better luck next time... maybe...
    BLOCK
  end

  def dealer_busts_message
    <<~BLOCK
      Damn it, the dealer busted! How come he didn't remember
      which card came next?! Anyway... Care about a rematch maybe?
    BLOCK
  end

  def gambler_wins_message
    <<~BLOCK
      You scored #{gambler.score} points while the dealer only
      scored #{dealer.score}: this is probably beginner's luck
      but you won this round. Care about proving you can do it again?
    BLOCK
  end

  def dealer_wins_message
    <<~BLOCK
      Awww this is unfortunate... The dealer scored
      #{dealer.score} points and your meager #{gambler.score}
      points can't keep up. Better luck next time!
    BLOCK
  end

  def no_one_wins_message
    <<~BLOCK
      You both scored #{gambler.score} points. You'll need
      another round to assert your undisputable Blackjack
      mastery!
    BLOCK
  end
end

Game.new.start
