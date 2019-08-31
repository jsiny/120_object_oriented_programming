class Banner
  attr_reader :message

  def initialize(message, fixed_length = message.size)
    @message = message
    @width = choose_largest_width(fixed_length)
  end

  def to_s
    [hor_rule, empty_line, message_line, empty_line, hor_rule].join("\n")
  end

  private

  def choose_largest_width(fixed_length)
    [fixed_length, @message.size + 2].max
  end

  def hor_rule
    '+' + '-' * @width + '+'
  end

  def empty_line
    '|' + ' ' * @width + '|'
  end

  def message_line
    "|#{@message.center(@width)}|"
  end
end

banner = Banner.new('To boldly go where no one has gone before.', 75)
puts banner
# +---------------------------------------------------------------------------+
# |                                                                           |
# |                To boldly go where no one has gone before.                 |
# |                                                                           |
# +---------------------------------------------------------------------------+

# banner = Banner.new('')
banner = Banner.new('To boldly go where no one has gone before')
puts banner
# +-------------------------------------------+
# |                                           |
# | To boldly go where no one has gone before |
# |                                           |
# +-------------------------------------------+

banner = Banner.new('To boldly go where no one has gone before', 30)
puts banner
# +-------------------------------------------+
# |                                           |
# | To boldly go where no one has gone before |
# |                                           |
# +-------------------------------------------+

banner = Banner.new(' ')
puts banner
# +---+
# |   |
# |   |
# |   |
# +---+
