
require 'pry'




puts "Hello New Yorker! Been here before?"

user_input = gets.chomp
sleep(1)
    if user_input == "Yes"
        sleep(1)
        puts "Welcome back!"
    else
        puts "Let's create an account for you! What's your name?"
        user_input = gets.chomp
        sleep(1)
        puts "Nice to meet you #{user_input}! What will be your password?"
        user_input = gets.chomp
        sleep(1)
        puts "Great, you're all set!"
    end

sleep(1)
puts "What train are you taking today?"

user_input = gets.chomp

# Custom message about train status

binding.pry
