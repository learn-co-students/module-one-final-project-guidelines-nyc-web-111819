
require_relative "../config/environment.rb"
require 'pry'
require 'io/console'
require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require "tty-prompt"


def findTrainStatus(currUser, trainName)
    status = (Line.find_by(train_name: trainName)).status
    search = Search.new(user_name: currUser.user_name, train_status: status, train_name: trainName, time: Time.new.to_s[0..-7])
    search.save
    status
end

def intro
  puts "Hello New Yorker! Been here before?"
  user_input = gets.chomp
    if user_input == "Yes" || user_input == "yes" || user_input == "Y" || user_input == "y"
        sleep(0.5)
        puts "Welcome back!" 
        sleep(0.5)
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
        sleep(0.5)
        f = true
        while f == true
            prompt = TTY::Prompt.new(enable_color: false)
            password = prompt.mask("Password: ")
            if password == currUser.password
                f = false
            else
                puts "Incorrect Password!"
            end
        sleep(0.5)
        end
    else
        puts "Let's create an account for you!"
        sleep(0.5)
        puts "What's your name?"
        user_input = gets.chomp
        sleep(0.5)
        puts "Nice to meet you #{user_input}!"
        prompt = TTY::Prompt.new(enable_color: false)
        password = prompt.mask("What will be your password? ")
        currUser = User.create(user_name: user_input, password: password)
        currUser.save
        sleep(0.5)
        puts "Great, you're all set!"
        sleep(0.5)
    end
    currUser
end

def train_selection(currUser)
    f = false
    while f == false
        puts "What train would you like to take?"
        user_input = gets.chomp
        if Line.find_by(train_name: user_input) == nil
            puts "Invalid train line!"
        else
            puts findTrainStatus(currUser, user_input)
            f = true
        end
    end
end

def another_train(currUser)
    f = true
    while f == true
        puts "Would you like to check another train?"
        user_input = gets.chomp
        if user_input == "Yes" || user_input == "yes" || user_input == "Y" || user_input == "y"
            sleep(0.7)
            train_selection(currUser)
        elsif user_input == "No" || user_input == "no" || user_input == "n" || user_input == "N"
            sleep(0.7)
            puts "Ok, have a great day!"
            f = false
        else
            "Invalid input!"
        end
    end
end

def view_searches(currUser)
    puts ""
    Search.where(user_name: currUser.user_name).order(created_at: :desc).each{|search| puts "[#{search.time}] #{search.train_name}: #{search.train_status}"}
end

def runner
    currUser = intro
    f = true
    while f == true
        puts "Press 't' to select a train, 's' to view search history, 'c' to clear search history, or 'u' to update your password. Press 'x' to exit."
        input = gets.chomp
        if input == 't'
            train_selection(currUser)
            another_train(currUser)
        elsif input == 's'
            view_searches(currUser)
        elsif input == 'u'
            prompt = TTY::Prompt.new(enable_color: false)
            password = prompt.mask("What will be your new password? ")
            currUser.password = password
            currUser.save
            sleep(0.5)
            puts "Password updated!"
        elsif input == 'x'
            puts "Goodbye!"
            f = false
        elsif input == 'c'
            Search.destroy_by(user_name: currUser.user_name)
            puts "Search history cleared!"
        else
            puts "Invalid input!"
        end
    end
end

runner