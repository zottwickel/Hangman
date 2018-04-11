
require "sinatra"
if development?
	require "sinatra/reloader"
end

# class Game
# 	attr_accessor :word_string
# 	def initialize(name)
# 		@name = name
# 		@time = Time.now
# 		@guess_count = 10
# 	end

# 	def noose
# 		if @guess_count < 10
# 			@floor = "============"
# 		else
# 			@floor = "            "
# 		end
# 		if @guess_count < 9
# 			@post = "|"
# 		else
# 			@post = " "
# 		end
# 		if @guess_count < 8
# 			@beam = "========"
# 		else
# 			@beam = "        "
# 		end
# 		if @guess_count < 7
# 			@rope = "!"
# 		else
# 			@rope = " "
# 		end
# 		if @guess_count < 6
# 			@head = "0"
# 		else
# 			@head = " "
# 		end
# 		if @guess_count < 5
# 			@torso = "+"
# 		else
# 			@torso = " "
# 		end
# 		if @guess_count < 4
# 			@rtarm = "-"
# 		else
# 			@rtarm = " "
# 		end
# 		if @guess_count < 3
# 			@lfarm = "-"
# 		else
# 			@lfarm = " "
# 		end
# 		if @guess_count < 2
# 			@rtleg = "\\"
# 		else
# 			@rtleg = " "
# 		end
# 		if @guess_count < 1
# 			@lfleg = "/"
# 		else
# 			@lfleg = " "
# 		end
# 		@stickman = "\n\n                   #{@beam}\n                   #{@rope}      #{@post}\n                   #{@head}      #{@post}\n                  #{@lfarm}#{@torso}#{@rtarm}     #{@post}\n                  #{@lfleg} #{@rtleg}     #{@post}\n                          #{@post}\n                #{@floor}\n"
#         puts @stickman
#     end

# 	def cpu_word_choice
# 		dic = File.readlines("5desk.txt")

# 		@cpu_choice = dic[rand(dic.length)].downcase

# 		until @cpu_choice.chomp.length >= 5 && @cpu_choice.chomp.length <= 12
# 			@cpu_choice = dic[rand(dic.length)].downcase
# 		end
# 		@cpu_choice = @cpu_choice.chomp
# 		@word_string = "_" * @cpu_choice.length
# 	end

# 	def guess
# 		puts "Enter your guess: (single letter or whole word)"
# 		puts "Type SAVE to save and quit, EXIT to exit without saving, or RESET to reset."
# 		@guess = gets.chomp
# 		if @guess == "SAVE"
# 			game_dump = YAML.dump($game)
# 			save_file = File.new("save/" + @name + ".yaml", "w").write(game_dump)
# 			exit
# 		elsif @guess == "EXIT"
# 			exit
# 		elsif @guess == "RESET"
# 			load "Hangman.rb"
# 		end
# 		@guess = @guess.downcase
# 		if @guess.length == @cpu_choice.length
# 			if @cpu_choice == @guess
# 				puts "YOU WIN! the word was indeed #{@cpu_choice}!"
# 				File.delete("save/" + @name + ".yaml") if File.exists?("save/" + @name + ".yaml")
# 				exit
# 			else
# 				system 'clear'
# 				puts "Sorry, wrong word!"
# 				@guess_count -= 1
# 			end
# 		elsif @guess.length == 1
# 			if @cpu_choice.include? @guess
# 				@cpu_choice.each_char.with_index do |x,y|
# 					if x == @guess
# 						@word_string[y] = x
# 						system 'clear'
# 						puts "Good guess! #{@guess} was part of the word!"
# 					end
# 				end
# 				if @word_string == @cpu_choice
# 					puts "YOU WIN! the word was indeed #{@cpu_choice}!"
# 					File.delete("save/" + @name + ".yaml") if File.exists?("save/" + @name + ".yaml")
# 					exit
# 				end
# 			else
# 				system 'clear'
# 				puts "Sorry, wrong letter!"
# 				@guess_count -= 1
# 			end
# 		else
# 			system 'clear'
# 			puts "You must enter a #{@cpu_choice.length}-letter word, or a single letter to guess!"
# 		end
# 	end

# 	def guess_check
# 		if @guess_count == 0
# 			puts "GAME OVER! You failed to guess the word!"
# 			puts "The word was #{@cpu_choice}."
# 			File.delete("save/" + @name + ".yaml") if File.exists?("save/" + @name + ".yaml")
# 			exit
# 		end
# 	end

# end

# Dir.mkdir("save") unless Dir.exists?("save")

# system 'clear'
# puts "Welcome to hangman!"
# 	if Dir.entries("save").length > 2
# 		puts "Save files found! Enter your game's name from the list, or type NEW to start a new game!\n"
# 		save_dir = Dir.entries("save")
# 		save_dir.each {|x| puts x.chomp(".yaml") + "\n" unless x == "." || x == ".."}
# 		puts "\n"
# 		file_name = gets.chomp
# 		if file_name == "NEW"
# 			puts "Enter your new game's name:"
# 			$game = Game.new(gets.chomp.downcase)
# 			$game.cpu_word_choice
# 		else
# 			$game = YAML.load(File.read( "save/" + file_name + ".yaml"))
# 			system "clear"
# 		end
# 	else
# 		puts "Enter your new game's name:"
# 		game_name = gets.chomp.downcase
# 		if Dir.entries("save").include? (game_name + ".yaml")
# 			while Dir.entries("save").include? (game_name + ".yaml")
# 				puts "Game name already exists!"
# 				game_name = gets.chomp.downcase
# 			end
# 		else
# 			$game = Game.new(game_name)
# 			$game.cpu_word_choice
# 		end
# 	end
# loop do
# 	$game.noose
# 	$game.word_string
# 	$game.guess
# 	$game.guess_check
# end

use Rack::Session::Cookie, 	:key => "rack.session",
							:path => "/",
							:secret => "this_is_really_hangman"

get "/" do
	if (session["word_string"] == nil) || (session["cpu_choice"] == nil)
		redirect "/new"
	end
	guess = params["guess"]
	message = "Hangman!"
	erb :index, :locals => {:message => message, :cpu_choice => session["cpu_choice"], :word_string => session["word_string"], :guess_count => session["guess_count"]}
end

get "/new" do
	pick_word
	session["cpu_choice"] = @cpu_choice
	session["word_string"] = @word_string
	session["guess_count"] = 10
	#message = ""
	#erb :index, :locals => {:message => message, :cpu_choice => session["cpu_choice"], :word_string => session["word_string"], :guess_count => session["guess_count"]}
	redirect "/" if session["word_string"] != nil
end


helpers do
	def pick_word
		dic = File.readlines("5desk.txt")
		@cpu_choice = dic[rand(dic.length)].downcase
		until @cpu_choice.chomp.length >= 5 && @cpu_choice.chomp.length <= 12
			@cpu_choice = dic[rand(dic.length)].downcase
		end
		@cpu_choice = @cpu_choice.chomp
		@word_string = "_ " * @cpu_choice.length
	end
end