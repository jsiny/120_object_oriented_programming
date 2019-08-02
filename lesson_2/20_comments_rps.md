# Comments about the Assignment "Rock-Paper-Scissors Bonus Features"

I'll explain here my design choices regarding the Assignment "Rock Paper
Scissors" game.

## 1. Keeping Score

I initially created a class `Score` in order to keep each player's score.
A new `Score` object would be created upon instantiation of a `Player` object.

```ruby
class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = Score.new
  end
end
```

The `Score` object would have the following instance methods:

```ruby
class Score
  attr_accessor :value

  POINTS_TO_WIN = 3

  def initialize
    @value = 0
  end

  def add_point
    @value += 1
  end

  def win?
    value >= POINTS_TO_WIN
  end
end
```

However, I then realised that this program never did any 'real' action
within the `Score` class. I was constantly referring to `Score` methods from
other classes, with the following pattern: `player.score.simple_action`.

For instance, at the start of a new game, I'd reset the scores to 0 like this:

```ruby
# Game loop
human.score.wipe
computer.score.wipe
```

I was taking advantage of my (simple) method `Score#wipe`. However, I could
have as easily written the following:

```ruby
human.score = 0
computer.score = 0
```

Thus saving myself the trouble of writing a `Score` method (and perhaps being
even clearer for the reader).

Therefore, I took the decision to refactor my program with score being a
**state** of `Player` (and not a class by itself):

```ruby
class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end
end
```

The result was a bit clearer and definitely shorter!

## 2. Add Lizard and Spock

With those 2 new choices and the added complexity they brought, I chose to
replace the neat `>(other_move)` method by a hash (so that Rubocop wouldn't
murder me with the Assignment Branch Condition offense):

* Before Lizard and Spock:

```ruby
def >(other_move)
  scissors? && other_move.paper? ||
    paper?  && other_move.rock?  ||
    rock?   && other_move.scissors?
end
```
* After Lizard and Spock:
```ruby
WINNING_MOVES = { 'rock'      => %w(scissors lizard),
                  'scissors'  => %w(paper lizard),
                  'paper'     => %w(rock spock),
                  'spock'     => %w(scissors rock),
                  'lizard'    => %w(paper spock) }

def >(other_move)
  WINNING_MOVES[value].include?(other_move.value)
end
```

This refactoring also allowed me to get rid of the `scissors?` & cie methods.

## 3. Add a class for each move

I've done this assignment in a [separate file](../12_rps_5_classes.rb).

I felt that adding 5 subclasses to `Move` mostly complicated my program.
I think the biggest 'pro' in favor of this design is simplifying the
`>(other_move)` logic, but as explained above, I had already done it
through a hash.

To be fair, I could have also re-written the `>(other_move)` method in each
subclass like this, which is arguably a bit more readable:

```ruby
class Rock < Move
  def >(other_move)
    other_move.class == Scissors || other_move.class == Lizard
  end
end
```

However, I felt that writing 5 different versions of this method (one for
each subclass) for a tad more readability was not a good tradeoff.

Therefore, to implement 5 empty classes, I had to change lots of details
throughout the code (among other things, referencing the Class from the String
through `Object.const_get`), for no gain in lisibility.

For the rest of the assignment, I've thus chosen to keep `Move` as one
class only.
