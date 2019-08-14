=begin
1. Initialize deck
2. Deal cards to player and dealer
3. Player turn: hit or stay
  - repeat until bust or "stay"
4. If player bust, dealer wins.
5. Dealer turn: hit or stay
  - repeat until total >= 17
6. If dealer bust, player wins.
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
  MAX_SIZE = 70
  LINE_BREAK = '-' * MAX_SIZE
  SMALL_BREAK = '-' * 15
  SLEEPING_TIME = 2

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
end

class Participant
  attr_accessor :hand

  def initialize
    @hand = []
  end
end

class Player < Participant
  # def initialize
  #   # What would be the states of a Player object? cards? a name?
  # end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
    # we'll need to know about cards to produce some total
  end
end

class Dealer < Participant
  attr_reader :second_card

  def initialize
    super
    @second_card = :hidden
  end

  def public_hand
    second_card == :hidden ? hand.first : hand.join(' ')
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
    # we'll need to know about cards to produce some total
  end
end

class Deck
  attr_accessor :deck

  SUITS   = %w(♠ ♥ ♦ ♣)
  VALUES  = %w(2 3 4 5 6 7 8 9 10 J Q K A)

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

  attr_reader :dealer, :player

  def initialize(dealer, player)
    @dealer = dealer
    @player = player
  end

  def display_cards
    print_center("Player's hand:")
    print_center(player.hand.join(' '))
    print_center(SMALL_BREAK)
    print_center("Dealer's hand:")
    print_center(dealer.public_hand)
    puts ''
  end
end

class Game
  include Tools

  attr_reader :deck, :player, :dealer, :table

  def start
    display_welcome_message
    setup_game
    deal_cards
    show_initial_cards
    player_turn
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
      Your goal: to get as close as possible to 21, without going overboard!
      #{LINE_BREAK}
      Understood? Press any key to start the game!
    BLOCK
  end

  def setup_game
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new
    @table = Table.new(dealer, player)
  end

  def deal_cards
    print_center('Shuffling cards...')
    2.times do
      player.hand << deck.deal
      dealer.hand << deck.deal
    end
    sleep SLEEPING_TIME
    clear
  end

  def show_initial_cards
    table.display_cards
  end
end

Game.new.start
