class ValidateAgeError < StandardError; end

def validate_age(age)
  raise(ValidateAgeError, "invalid age") unless (0..105).cover?(age)
end

age = 107

begin
  validate_age(age)
rescue ValidateAgeError => e
  puts e.message
  puts e.backtrace
end

# Output:
# => "invalid age"
# => 6_exceptions.rb:4:in `validate_age'
# => 6_exceptions.rb:10:in `<main>'
