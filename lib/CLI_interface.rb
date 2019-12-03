
require 'pry'

puts "Hello New Yorker! Been here before?"

user_input = gets.chomp
# sleep(0.7)
    if user_input == "Yes"
        sleep(0.7)
        puts "Welcome back!" 
        sleep(0.7)
    else
        puts "Let's create an account for you!"
        sleep(0.5)
        puts "What's your name?"
        user_input = gets.chomp
        sleep(0.7)
        puts "Nice to meet you #{user_input}! What will be your password?"
        user_input = gets.chomp
        sleep(0.7)
        puts "Great, you're all set!"
        sleep(0.7)
    end


puts "What train are you taking today?"

user_input = gets.chomp

# Custom message about train status

sleep(1)
puts "Would you like to check another train?"

user_input = gets.chomp

if user_input == "Yes"
    sleep(0.7)
    puts "What train are you thinking of?" 
    user_input = gets.chomp
    # Custom message about train status
else
    sleep(0.7)
    puts "Have a great day!"
end


# binding.pry
