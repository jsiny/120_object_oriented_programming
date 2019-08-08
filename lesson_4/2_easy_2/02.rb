class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

trip = RoadTrip.new
p trip.predict_the_future

# This program returns a string with the form of "You will <some trip>"
# with the "some trip" being one of the three choices in
# Roadtrip#choices. The choice is chosen randomly.

# Since we're calling predict_the_future on an instance of RoadTrip,
# Ruby will start with the methods defined on the class called.
# So even though the call to choices happens in a method defined in
# Oracle, Ruby will first look for a definition of choices in
# RoadTrip before falling back to Oracle.
