require 'colorize'
require 'colorized_string'

PROMPT = TTY::Prompt.new

@@user = nil
@@concert_name = nil

def run
    welcome
end

#welcome
def welcome
    puts "🎶 " " 🤩  " "Welcome to Music Source!" "  🤩 " " 🎶".colorize(:yellow)
    new_user
    options
    get_artist_events
end

#Allows user to Sign up or Login
    def new_user
        new_user = PROMPT.yes?("Would you like to Sign Up?😏".colorize(:yellow))
        if new_user == true
            signup
        else 
            login
        end
    end

#Helper method that asks User to sign up
    def signup
        username = PROMPT.ask("Please create a username:".colorize(:yellow), required: true)
        @@user = create_user(username)
    end

    def create_user(username)
        User.create(name: "#{username}") 
    end

# User login
def login
    username = PROMPT.ask("Welcome Back!😄 What's your Username?🤔🧐".colorize(:yellow), required: true)
        user = User.find_by(name: username)
        if user 
            @@user = user
        else
            PROMPT.error("Sorry Username Not Found!")
            signup
        end
        binding.pry
end

def options 
    selection = PROMPT.select("What would you like to do?") do |option|
        option.choice "Find event by artist", 1
        option.choice "Show my events", 2
        option.choice "Delete an event", 3
        option.choice "Delete account", 4
        option.choice "Profile", 5
        option.choice "Exit", 6
    end 
    if selection == 1 
        artist = artist_prompt
        event_list = get_artist_events(artist)
        choose_concert(event_list)
        go_back
    elsif 
        selection == 2
        show_my_events 
        sleep(3)
        go_back
    elsif 
        selection == 3 
        delete_event
        puts "Your event was succesfully deleted!"
        go_back
    elsif 
        selection == 4 
        delete_myself 
        exit
    elsif
        selection == 5
        update_username
        go_back

    else
        sleep (1)
            puts "Goodbye!"
            exit
    end
end 

def artist_prompt
    puts "Input your favorite artist:"
    user_input = gets.chomp 
end

def get_artist_events(artist)
    #get artist id
    artist_string = RestClient.get("https://api.songkick.com/api/3.0/search/artists.json?apikey=io09K9l3ebJxmxe2&query=#{artist}")
    artist_hash = JSON.parse(artist_string)
    artist_id = artist_hash["resultsPage"]["results"]["artist"][0]["id"]

    #look at Songkick and find list of events in a timeframe we set with that particular artist
    events_string = RestClient.get("https://api.songkick.com/api/3.0/artists/#{artist_id}/calendar.json?apikey=io09K9l3ebJxmxe2
     ")
    events_hash = JSON.parse(events_string)
         
    #map through and get array of display name for event
    event_array = events_hash["resultsPage"]["results"]["event"].map do |event|
        event["displayName"]
    end 
end

def choose_concert(event_list)
    selection = PROMPT.select("Choose your concert?", event_list)
    new_concert = Concert.create(name: "#{selection}")
    new_event = Event.create(user_id: "#{@@user.id}", concert_id: "#{new_concert.id}", name: "#{selection}")
    puts "You just saved an event!"
end 

def show_my_events 
    event_names.each do |event_name|
        puts event_name
    end 
    choice = PROMPT.select("Would you like to go back?", ["yes"])
    if choice == "yes"
        go_back
    end
end 

def concert_names
    @@user.reload.concerts.map do |concert|
        concert.name
    end 
end

def event_names 
    @@user.reload
    @@user.events.map do |event|
        event.name 
    end 
end 

def select_event
    event_name = PROMPT.select("Which event are you looking for?", event_names)
    Event.find_by(name: "#{event_name}")
end

def destroy_all_users
    User.all.each do |user|
        user.destroy 
    end 
end 

def delete_myself
    @@user.destroy
end 

def delete_event
    if @@user.events.length == 0 
        puts "#{@@user.name} has no events!"
        PROMPT.yes?("Would you like to go back?")
        go_back  
    end
    puts "Here are #{@@user.name}'s events!"
    my_event = select_event
    my_event.destroy
    @@user.reload
    puts "Event Succesfully Deleted!"
    PROMPT.yes?("Would you like to go back?")
    go_back  
end

def update_username
    puts "Welcome #{@@user.name}, to your profile!"
    PROMPT.yes?("Would you like to change your Username?")
    if "yes"
        input = gets.chomp
        @@user.update(name: "#{input}")
    end
end


def go_back
    sleep(2)
    options
end

