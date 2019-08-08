class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Ben is correct.

# In the `positive_balance?` method, it's the
# getter method `balance` that is referenced, not the instance
# variable `@balance`.
# Additionally, the getter method is defined through the
# attr_reader :balance and is accessible within positive_balance?

# Sorry Alyssa, I'm with Ben!
