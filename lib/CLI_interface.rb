
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
        f = true
        while f == true
            puts "What's your account name?"
            user_input = gets.chomp
            if User.find_by(user_name: user_input) == nil
                puts "User not found!"
            else
                currUser = User.find_by(user_name: user_input)
                f = false
            end
        end
        sleep(0.6)
        f = true
        while f == true
            $stdout.puts "Password: "
            password = $stdin.noecho(&:gets)
            password.strip!
            if password == currUser.password
                f = false
            else
                puts "Incorrect Password!"
            end
        sleep(0.6)
        end
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
    puts "What train would you like to take?"
    user_input = gets.chomp
    puts findTrainStatus(user_input)
end 

def another_train
    f = true
    while f == true
        puts "Would you like to check another train?"
        user_input = gets.chomp
        if user_input == "Yes" || user_input == "yes" || user_input == "Y" || user_input == "y"
            sleep(0.7)
            train_selection
        else
            sleep(0.7)
            puts "Ok, have a great day!"
            f = false
        end
    end
end

def runner
    intro
    f = true
    while f == true
        puts "Press 't' to select a train, 's' to view search history, or 'x' to exit, "
        input = gets.chomp
        if input == 't'
            train_selection
            another_train
        elsif input == 's'
            view_searches
        elsif input == 'x'
            puts "Goodbye!"
            f = false
        else
            puts "Invalid input!"
        end
    end
end

runner