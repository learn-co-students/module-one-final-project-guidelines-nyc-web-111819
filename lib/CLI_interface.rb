
require_relative "../config/environment.rb"
require 'pry'
require 'io/console'
require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require_relative 'api.rb'


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
        currUser = User.create(user_name: user_input, password: password)
        currUser.save
        sleep(0.6)
        puts "Great, you're all set!"
        sleep(0.6)
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
            status = findTrainStatus(currUser, user_input)
            puts status
            if status != "GOOD SERVICE"
                puts "Press 'e' for more information or any other key to continue"
                user = gets.chomp
                if user == 'e'
                    status = (Line.find_by(train_name: user_input)).elaborate
                    if status.class == String
                        puts status
                    else
                        status.flatten.each{|alert| puts alert}
                    end
                end
            end
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
    if Search.where(user_name: currUser.user_name) == []
        sleep(0.5)
        puts "No history!"
    else
        sleep(0.5)
        Search.where(user_name: currUser.user_name).order(created_at: :desc).each{|search| puts "[#{search.time}] #{search.train_name}: #{search.train_status}"}
    end
end

def runner
    sorting_api_data
    currUser = intro
    f = true
    while f == true
        puts "Press 't' to select a train, 's' to view search history, 'c' to clear search history, or 'x' to exit, "
        input = gets.chomp
        if input == 't'
            train_selection(currUser)
            another_train(currUser)
        elsif input == 's'
            view_searches(currUser)
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