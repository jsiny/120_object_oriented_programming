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
    print wordwrap(welcome_message)
  end

  def welcome_message
    <<~BLOCK
      Welcome to our Special Casino, where you can only play (some kind of) \
      BlackJack!
    BLOCK
  end

  def wordwrap(str, width = 60)
    char_count = 0
    lastchar = str.end_with?(' ') ? ' ' : ''
    str.split(/ /).each do |word|
      char_count += word.size + 1
      if char_count > width
        word.prepend("\n") unless word.start_with?("\n\n")
        char_count = word.size + 1
      end
      char_count = word.size - 1 if word.include?("\n\n")
    end.join(' ') << lastchar
  end

end

Game.new.start

# print wordwrap

# Assumes "space plus \n\n" for new paragraph.
# def word_wrap(str, width = App::SCREEN_WIDTH)
#   char_count = 0
#   lastchar = str.end_with?(' ') ? ' ' : ''
#   str.split(/ /).each do |word|
#     char_count += word.size + 1
#     if char_count > width
#       word.prepend("\n") unless word.start_with?("\n\n")
#       char_count = word.size + 1
#     end
#     char_count = word.size - 1 if word.include?("\n\n")
#   end.join(' ') << lastchar
# end

# SCREEN_WIDTH = 60

# <<~BLOCK
#       Welcome #{@gambler.name}!
#       You have been awarded a gambling spree at General Rodes Black Jack, \
#       our favorite casino!#{SPACE}
#       Black Jack is the game we play ... sort of. No doubling down, and no \
#       splitting pairs.#{SPACE}
#       You have $#{GAMBLER_STAKE} to play with. Bet is $#{BET} per hand.#{SPACE}
#       Black Jack (natural #{App::BUST_VALUE}) pays #{NATURAL_MULTIPLIER} \
#       to 1. Good luck!#{SPACE}
#       Please hit #{KEY_ONLY ? 'any key' : '"Enter"'} when you are ready to \
#       begin:#{SPACE}
#     BLOCK
