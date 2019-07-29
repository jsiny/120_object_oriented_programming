class Selectra
	def initialize(name, title)
		@name = name
		@title = title
	end

	def print_position
	  puts "Hi, I'm #{@name} and I work as a #{@title}!"
	end
end

juliette = Selectra.new("Juliette", "Gif manager")
juliette.print_position

victor = Selectra.new("Victor", "Docker warlord")
victor.print_position