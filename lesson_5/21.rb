=begin
1. Initialize deck
2. Deal cards to gambler and dealer
3. Gambler turn: hit or stay
  - repeat until bust or "stay"
4. If gambler bust, dealer wins.
5. Dealer turn: hit or stay
  - repeat until total >= 17
6. If dealer bust, gambler wins.
7. Compare cards and declare winner.

- cards
- deck
* deal

- players:
* hit
* stay
* busted?
* total

> Human
> dealer

- game
* compare cards
* play
=end

module Tools
  MAX_SIZE      = 70
  LINE_BREAK    = '-' * MAX_SIZE
  SMALL_BREAK   = '-' * 15
  SLEEPING_TIME = 1
  SEPARATOR     = '*'
  MAX_SCORE     = 21 # not sure this should be here

  def wrap_sentence(str, max_size)
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
  attr_reader :want_to_stay

  def initialize(deck)
    @hand = []
    @deck = deck
    @want_to_stay = false
  end

  def score
    @score = 0
    hand.each do |card|
      @score += if numeric_string?(card[0])
                  card[0].to_i
                elsif Deck::HEADS.include?(card[0])
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
    @score > MAX_SCORE
  end

  def stay
    @want_to_stay = true
  end

  private

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
    case choose_action
    when 'h' then hit
    when 's' then stay
    end
  end

  private

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

  # def hit
  # end

  # def stay
  # end

  # def busted?
  # end

  def score
    if second_card == :hidden
      '?'
    else
      super
    end
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
    gambler_turn
    dealer_turn
    show_result
  end

  private

  def display_welcome_message
    clear
    wrap_sentence(welcome_message, MAX_SIZE)
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
    sleep SLEEPING_TIME
    clear
  end

  def display_cards
    table.display_cards_and_scores
  end

  def gambler_turn
    loop do
      display_cards
      break if gambler.busted? || gambler.want_to_stay
      gambler.play
      clear
    end
  end
end

Game.new.start
