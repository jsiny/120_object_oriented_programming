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
  MAX_SIZE = 45
  LINE_BREAK = '-' * MAX_SIZE

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
end

class Player
  def initialize
    # What would be the states of a Player object? cards? a name?
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

class Dealer
  def initialize
    # seems very similar to player... do we need this?
  end

  def deal
    # is it the dealer's work or the deck's?
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

class Participant
  # Should we include all the redundant behaviors from Player and Dealer?
end

class Deck
  def initialize
    # obviously, we need some data structure to keep track of cards.
  end

  def deal
    # does the Dealer or Deck deal?
  end
end

class Card
  def initialize
    # what are the states of a card?
  end

  # ace?
end

class Table
  # display cards and score
end

class Game
  include Tools

  def start
    display_welcome_message
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
  end

  def welcome_message
    <<~BLOCK
      Welcome to our Special Casino, where you can only play (some kind of) \
      BlackJack!
      #{LINE_BREAK}
      Each card has a value: numbers are worth their face value, figures are 
      worth 10 points, and an ace can be worth 1 or 10.
      Your goal: to get as close as possible to 21, without going overboard! 
    BLOCK
  end
end

Game.new.start
