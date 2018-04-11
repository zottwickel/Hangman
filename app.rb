require "sinatra"
require "sinatra/reloader" if development?

dic = File.readlines("5desk.txt")
choice = dic[rand(dic.length)].downcase
until choice.chomp.length >= 5 && choice.chomp.length <= 12
	choice = dic[rand(dic.length)].downcase
end
$cpu_choice = choice.chomp
$guess_count = 10
$choice_string = "_" * $cpu_choice.length
$message = nil




get "/" do
	guess = params["guess"]
	make_guess(guess) unless guess == nil
	if $message == "You Win! Making new string!"
		dic = File.readlines("5desk.txt")
		choice = dic[rand(dic.length)].downcase
		until choice.chomp.length >= 5 && choice.chomp.length <= 12
			choice = dic[rand(dic.length)].downcase
		end
		$cpu_choice = choice.chomp
		$guess_count = 10
		$choice_string = "_" * $cpu_choice.length
	end
	erb :index, :locals => {:cpu_choice => $cpu_choice, :guess_count => $guess_count, :choice_string => $choice_string, :message => $message}
end

helpers do

	def make_guess(guess)
		if $guess_count == 0
			$message = "You lose! Getting new word."
			dic = File.readlines("5desk.txt")
			choice = dic[rand(dic.length)].downcase
			until choice.chomp.length >= 5 && choice.chomp.length <= 12
				choice = dic[rand(dic.length)].downcase
			end
			$cpu_choice = choice.chomp
			$guess_count = 10
			$choice_string = "_" * $cpu_choice.length
		elsif guess == $cpu_choice
			$message = "You Win! Making new string!"
			$choice_string = guess
		elsif $cpu_choice.include?(guess) && (guess.length == 1)
			$cpu_choice.each_char.with_index do |x,y|
				if x == guess
					$choice_string[y] = x
				end
				if $choice_string.include?("_") == false
					$message = "You Win! Making new string!"
				end
			end
		elsif ($cpu_choice.include?(guess) == false) && (guess.length == 1)
			$message = "The word doesn't contain that letter!"
			$guess_count -= 1
		elsif (guess.length != $choice_string.length) && (guess.length > 1)
			$message = "Enter a letter or a word of the right length!"
		elsif (guess != $cpu_choice) && (guess.length == $cpu_choice.length)
			$message = "Sorry wrong word."
			$guess_count -= 1
		end
	end

end