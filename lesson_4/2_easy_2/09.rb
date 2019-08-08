class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end

  def play
    "Let's play bingo!"
  end
end

# Adding a play method to Bingo would override the Game#play
# method for instances of Bingo

puts Bingo.new.play
# => "Let's play bingo!"
