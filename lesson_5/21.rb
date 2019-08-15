module Tools
  MAX_SIZE      = 40
  LINE_BREAK    = '-' * MAX_SIZE
  SMALL_BREAK   = '-' * 15
  SLEEPING_TIME = 1
  MAX_SCORE     = 21

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
  attr_reader :exit_strategy, :name, :victory_points

  def initialize(deck)
    @name           = choose_name
    @victory_points = 0
    reset_hand_and_score(deck)
  end

  def reset_hand_and_score(deck)
    @hand           = []
    @deck           = deck
    @exit_strategy  = nil
  end

  def turn(table)
    loop do
      sleep SLEEPING_TIME
      clear
      table.display
      break if busted? || stayed?
      play
    end
  end

  def add_point
    @victory_points += 1
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

  def busted?
    @exit_strategy = :busted if @score > MAX_SCORE
  end

  def stayed?
    @exit_strategy == :stayed
  end

  private

  def play
    case choose_action
    when 'h' then hit
    when 's' then stay
    end
  end

  def hit
    hand << deck.deal
  end

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

  def choose_to_play_again?
    answer = ''
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts 'Sorry, I may not have been clear enough.'
      puts 'Do you want to play again? (y/n)'
    end
    answer == 'y'
  end

  def public_hand
    hand.join(' - ')
  end

  private

  def play
    puts ''
    puts "It's your turn!"
    super
  end

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

  def choose_name
    name = ''
    loop do
      puts "What's your name dear?"
      name = gets.chomp.delete('^a-zA-Z ').strip.capitalize
      break unless name.empty?
      puts 'Sorry but you must enter a valid name'
    end
    name
  end
end

class Dealer < Player
  attr_reader :second_card
  FAMOUS_BLACKJACK_PLAYERS = ['Bryce Carlson', 'Cathy Hulbert',
                              'Arnold Snyder', 'Alice Walker',
                              'Stanford Wong', 'Eleanore Dumont']

  def reset_hand_and_score(deck)
    @second_card = :hidden
    super
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

  def reveal_hand
    @second_card = :revealed
  end

  private

  def play
    puts ''
    puts "It's now the dealer's turn!"
    super
  end

  def choose_action
    @score >= 17 ? 's' : 'h'
  end

  def choose_name
    FAMOUS_BLACKJACK_PLAYERS.sample
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

  def deal
    deck.shift
  end

  private

  def shuffle_deck
    @deck = []
    SUITS.each do |suit|
      VALUES.each { |value| deck << value + ' ' + suit }
    end
    deck.shuffle!
  end
end

class Table
  include Tools

  attr_reader :dealer, :gambler

  def initialize(dealer, gambler)
    @dealer = dealer
    @gambler = gambler
  end

  def display
    display_points
    display_hand_and_score(gambler)
    print_center(SMALL_BREAK)
    display_hand_and_score(dealer)
  end

  private

  def display_hand_and_score(player)
    print_center("#{player.name.split.first}'s hand:")
    print_center(player.public_hand)
    puts ''
    print_center("Score: #{player.score}")
  end

  def display_points
    print_center(LINE_BREAK)
    print_center("NUMBER OF ROUNDS WON")
    print_center("#{gambler.name}: #{gambler.victory_points}")
    print_center("#{dealer.name}: #{dealer.victory_points}")
    print_center(LINE_BREAK)
    puts ''
  end
end

class Game
  include Tools

  attr_reader :deck, :gambler, :dealer, :table

  def play
    setup_game
    game_round
  end

  private

  def game_round
    loop do
      deal_cards
      players_turn
      show_result
      break unless play_again?
      reset_game
    end
    display_closing_message
  end

  def display_welcome_message
    clear
    wrap_sentence(welcome_message)
  end

  def welcome_message
    <<~BLOCK
      Welcome to our Special Casino, where you can only play (some kind of)
      blackjack!
      #{LINE_BREAK}
      Each card has a value: numbers are worth their face value, figures are
      worth 10 points, and an ace can be worth 1 or 11.
      Your goal: to get as close as possible to #{MAX_SCORE}, without going
      overboard!
      #{LINE_BREAK}
    BLOCK
  end

  def setup_game
    display_welcome_message
    @deck = Deck.new
    @dealer = Dealer.new(deck)
    @gambler = Gambler.new(deck)
    @table = Table.new(dealer, gambler)
    announce_players
  end

  def announce_players
    wrap_sentence(players_introduction_message)
    gets
    clear
  end

  def players_introduction_message
    <<~BLOCK
      #{LINE_BREAK}
      #{gambler.name}? Great! You'll be playing against #{dealer.name}, who may
      or may not go easy on you... Well this is gonna be fun!
      #{LINE_BREAK}
      Press any key when you're ready!
    BLOCK
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
      dealer.add_point
      gambler_busts_message
    elsif dealer.exit_strategy == :busted
      gambler.add_point
      dealer_busts_message
    else
      compare_scores
    end
  end

  def compare_scores
    if gambler.score > dealer.score
      gambler.add_point
      gambler_wins_message
    elsif dealer.score > gambler.score
      dealer.add_point
      dealer_wins_message
    else
      no_one_wins_message
    end
  end

  def gambler_busts_message
    <<~BLOCK
      You busted! Told you, you shouldn't have pushed your luck... Better
      luck next time!
      #{LINE_BREAK}
      Let's try now shall we? (y/n)
    BLOCK
  end

  def dealer_busts_message
    <<~BLOCK
      Damn it, the dealer busted! How come the fool didn't remember which card
      came next?! Anyway...
      #{LINE_BREAK}
      Care for a rematch maybe? (y/n)
    BLOCK
  end

  def gambler_wins_message
    <<~BLOCK
      You scored #{gambler.score} points while the dealer only scored
      #{dealer.score}: this is probably beginner's luck but you won this round.
      #{LINE_BREAK}
      Care about proving you can do it again? (y/n)
    BLOCK
  end

  def dealer_wins_message
    <<~BLOCK
      Awww this is unfortunate... #{dealer.name} scored #{dealer.score} points
      and your meager #{gambler.score} points can't keep up. Better luck
      next time!
      #{LINE_BREAK}
      Let's try again shall we? (y/n)
    BLOCK
  end

  def no_one_wins_message
    <<~BLOCK
      You both scored #{gambler.score} points. You'll need another round to
      assert your undisputable blackjack mastery!
      #{LINE_BREAK}
      You do want to prove that, right? (y/n)
    BLOCK
  end

  def play_again?
    return unless gambler.choose_to_play_again?
    puts "And here we go again!"
    sleep SLEEPING_TIME
    clear
    true
  end

  def reset_game
    @deck = Deck.new
    dealer.reset_hand_and_score(deck)
    gambler.reset_hand_and_score(deck)
  end

  def display_closing_message
    wrap_sentence(closing_message)
  end

  def closing_message
    <<~BLOCK
      #{LINE_BREAK}
      Well then! It has been a *real* pleasure to try and crook you
      #{gambler.name}. Come back soon!
      #{LINE_BREAK}
    BLOCK
  end
end

Game.new.play
