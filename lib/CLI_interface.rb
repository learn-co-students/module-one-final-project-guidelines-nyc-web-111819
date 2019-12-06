
require_relative "../config/environment.rb"
require_relative 'api.rb'
require_relative 'location.rb'
require 'pry'
require 'io/console'
require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require "tty-prompt"
require 'colorize'
require 'catpix'


def findTrainStatus(currUser, trainName)
    status = (Line.find_by(train_name: trainName)).status
    search = Search.new(user_name: currUser.user_name, train_status: status, train_name: trainName, time: Time.new.to_s[0..-7])
    search.save
    status
end


def intro
    system "clear"
    Catpix::print_image "lib/subway lines.png"
    sleep(1.2)
    clear
    puts "Hello New Yorker! Tried us before?"
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
        print "Nice to meet you #{user_input}! "
        if User.find_by(user_name: user_input)
            puts "Oh oh, we already have #{user_input} in our database. Please pick a different name."
            user_input = gets.chomp
        end
        prompt = TTY::Prompt.new(enable_color: false)
        password = prompt.mask("Great, what will be your password? ")
        currUser = User.create(user_name: user_input, password: password)
        currUser.save
        sleep(0.5)
        puts "Great, you're all set!"
        sleep(0.5)
    end
    currUser
end

def train_selection(currUser, auto, *auto_input)
    f = false
    validInput = false
    while f == false
        if auto == false
            clear
            puts "What train would you like to take?"
            user_input = gets.chomp
            user_input.capitalize!
            if Line.find_by(train_name: user_input) == nil
                puts "Invalid train line!"
                sleep(1)
                validInput = false
            else
                validInput = true
            end
        end
        if auto == true
            user_input = auto_input
        end
        if validInput == true || auto == true
            if auto == true
                puts ""
                puts user_input
                user_input = user_input
            end
            status = findTrainStatus(currUser, user_input[0])
            elaboration = (Line.find_by(train_name: user_input[0])).elaborate
            elaboration = elaboration.gsub("Dec"," Dec")
            elaboration = elaboration.gsub("Planned Work","~Planned Work")
            elaboration = elaboration.gsub("Delays","~Delays")
            elaboration = elaboration.gsub("SOME REROUTES", "~SOME REROUTES")
            elaboration = elaboration.split("~")
            elaboration = elaboration.map{|item| item[0..-2]}
            screen = elaboration.select{|alert| alert.include? "[#{user_input[0]}]"}
            if screen.length == 0
                status = "GOOD SERVICE"
            end
            case 
            when status.include?("GOOD SERVICE")
                pid = fork{ exec 'mpg123', '-q', "lib/audio/tada-sound.mp3" }
                puts "#{status} 🍾 🙌 🎉".colorize(:green)
            when status.include?("PLANNED WORK")
                pid = fork{ exec 'mpg123', '-q', "lib/audio/game-fail-sound-effect.mp3" }
                puts "#{status} ⚙️ 🛠".colorize(:yellow)
            when status.include?("DELAYS")
                pid = fork{ exec 'mpg123', '-q', "lib/audio/game-fail-sound-effect.mp3" }
                puts "#{status} ⚠️ 🚨".colorize(:red)
            when status.include?("REROUTES")
                puts "#{status} ⚠️ 👹".colorize(:red)
            else
                puts status.colorize(:blue)
            end

            if status != "GOOD SERVICE"
                puts "Press 'i' for more information or any other key to continue"
                user = gets.chomp
                if user == 'i'
                    screen.each do |item|
                        puts ""
                        puts item
                        puts ""
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
        puts "Would you like to check another train? (yes/no)"
        user_input = gets.chomp
        if user_input == "Yes" || user_input == "yes" || user_input == "Y" || user_input == "y"
            sleep(0.7)
            clear
            train_selection(currUser, false)
        elsif user_input == "No" || user_input == "no" || user_input == "n" || user_input == "N"
            sleep(0.7)
            clear
            puts "Ok, have a great day!"
            f = false
        else
            "Invalid input!"
        end
    end
end

def view_searches(currUser)
    system "clear"
    if Search.where(user_name: currUser.user_name) == []
        sleep(0.5)
        puts "No history!"
    else
        sleep(0.5)
        Search.where(user_name: currUser.user_name).order(created_at: :desc).each{|search| puts "[#{search.time}] #{search.train_name}: #{search.train_status}"}
    end
end

def clear
    system "clear"
end

def runner
    sorting_api_data
    currUser = intro
    clear
    f = true
    while f == true
        puts "Press 't' to select a train, 'l' to check status of nearest train lines, 's' to view search history, 'c' to clear search history, or 'u' to update your password. Press 'x' to exit."
        input = gets.chomp
        if input == 't'
            train_selection(currUser, false)
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
            system "clear"
            pid = fork{ exec 'mpg123', '-q', "lib/audio/big-crowd-cheering.mp3" }
            Catpix::print_image "lib/giphy.gif"
            sleep(5)
            system "clear"
            f = false
        elsif input == 'l'
            puts "Enter your current location!"
            query = gets.chomp
            answer = station_by_location(query)
            clear
            puts answer[0]
            lines = answer[1]
            lines = lines.split("")
            lines.each{|line| train_selection(currUser, true, line)}
            puts "Press any key to continue"
            input = gets.chomp
            puts "Press 'd' for directions to this station"
            input = gets.chomp
            if input == 'd'
                clear
                puts answer[2]
            end
            puts "Press any key to continue"
            input = gets.chomp
            clear
        elsif input == 'c'
            Search.destroy_by(user_name: currUser.user_name)
            puts "Search history cleared!"
        else
            puts "Invalid input!"
        end
    end
end
