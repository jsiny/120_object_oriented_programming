# Discussion on object oriented Tic Tac Toe Code

## Idea 1

To alleviate the burden of manually testing the game everytime a change is
done, we could implement automatic tests to catch any regression.

## Idea 3

If we were to wrap this game up into a gem, and allow other developers to 
use it, we should use a namespace for our application's classes:

```ruby
module TicTacToe

  class Board
  end

  class Player
  end

  class Square
  end

  class Game
  end
end

TicTacToe::Game.new.play
```

This way, we're sure that the quite generic names `Player` or `Board`
will not colide with other classes.

## Idea 4

Do we really need a `Player` class? I think that for now, the `Player`
class hasn't been very useful, and we could have instead initialized
2 markers directly:

```ruby
class Game

  def initialize
    # rest of the code omitted
    @human_marker = HUMAN_MARKER
    @computer_marker = COMPUTER_MARKER
  end
end
```

However, as the game gets more complex, it's really likely that we'll
want to create some logic within the `Player` class, that wouldn't really fit
within the `Square` or `Board` classes (eg. score management)
