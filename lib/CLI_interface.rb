
require_relative "../config/environment.rb"
require 'pry'
require 'io/console'
require 'active_support'
require 'active_support/core_ext'
require 'active_record'


def findTrainStatus(trainName)
    (Line.find_by(train_name: trainName)).status
end

def intro
  puts "Hello New Yorker! Been here before?"
  user_input = gets.chomp
    if user_input == "Yes" || user_input == "yes" || user_input == "Y" || user_input == "y"
        sleep(0.6)
        puts "Welcome back!" 
        sleep(0.6)
        puts "What's your account name?"
        user_input = gets.chomp
        sleep(0.6)
        $stdout.puts "Password: "
        password = $stdin.noecho(&:gets)
        password.strip!
        sleep(0.6)
    else
        puts "Let's create an account for you!"
        sleep(0.5)
        puts "What's your name?"
        user_input = gets.chomp
        sleep(0.6)
        puts "Nice to meet you #{user_input}!"
        $stdout.print "What will be your password? "
        password = $stdin.noecho(&:gets)
        password.strip!
        sleep(0.6)
        puts "Great, you're all set!"
        sleep(0.6)
    end
end

def train_selection
    puts "What train are you taking today?"
    user_input = gets.chomp
    puts findTrainStatus(user_input)
end 

sleep(1)
puts "Would you like to check another train?"

user_input = gets.chomp

if user_input == "Yes" || user_input == "yes" || user_input == "Y" || user_input == "y"
    sleep(0.7)
    puts "What train are you thinking of?" 
    user_input = gets.chomp
    
    # Custom message about train status
else
    sleep(0.7)
    puts "Have a great day!"
end


# binding.pry
