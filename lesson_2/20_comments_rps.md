# Comments about the Assignment "Rock-Paper-Scissors Bonus Features"

I'll explain here my design choices regarding the Assignment "Rock Paper
Scissors" game.

## 1. Keep track of the score

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

I've done this assignment in a [separate file](/12_rps_5_classes.rb).

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
through `Object.const_get`), for no gain in legibility.

For the rest of the assignment, I've thus chosen to keep `Move` as one
class only.

## 4. Keep track of a history of moves

As the history of moves is an element related to the player (it's *their* choice
and this history must 'survive' the end of a round), I thought it would
be best to include it as a state to the `Player` class.

```ruby
class Player
  attr_accessor :move, :name, :score, :history

  def initialize
    set_name
    @score = 0
    @history = Hash.new(0)
  end
end
```

I've chosen to host this data as a hash in order to have as key the choice,
and as value the number of times the player selected the option.

My reasoning behind this was: there are probably two informations that might
be of interest while choosing a new option:
- Which option was picked last?
- Does the player have a tendency to use a choice more frequently?

I thought that the second question was the most interesting therefore I
opted for a "count" hash. Besides, we could also easily implement a
variable `last_choice` that could answer the first question.

## 5. Adjust computer choice based on history

That assignment was trickier than I thought.

I wanted to implement a feature allowing the Computer to better select
its choices. My goal was to spot humans with repetitive preferences.
For instance, if the player repeatedly selected 'rock', then the computer
would choose 'spock' or 'paper'.

At first, I tried to access the Human's history from the `Computer` class,
which proved tricky. I couldn't access the history without tracking it with
an instance variable within the `Computer` class (eg. having both
`@history` and `@opponent_history`). As instance variables are supposed
to reflect the *state* of an Object, this choice didn't feel right.

Therefore, I've tweaked a bit my code and ended up with a slight change
to my game loop (in `Game#play`): `computer.choose(human.history)`. With this
argument, `Computer` gain access to `human.history`!

My new `Computer` class looks like that:

```ruby
class Computer < Player
  START_ANALYZING_HISTORY = 3

  def choose(opponent_history)
    choice = if history.values.sum < START_ANALYZING_HISTORY
               Move::WINNING_MOVES.keys.sample
             else
               select_winner(opponent_history)
             end

    self.move = Move.new(choice)
    @history[choice] += 1
  end

  private

  def find_favorite(opponent_history)
    opponent_history.key(opponent_history.values.max)
  end

  def select_winner(opponent_history)
    favorite = find_favorite(opponent_history)
    Move::LOSING_MOVES[favorite].sample
  end
end
```

The "smart choices" only start to be applied after 3 rounds (hence the
`START_ANALYZING_HISTORY` constant), because we can't reveal a trend sooner
without unveiling the player's choice.
