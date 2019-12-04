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
    puts "🎶 " " 🤩  " "Welcome to Music Source!" "  🤩 " " 🎶"
    new_user
    options
    get_artist_events
end

#Allows user to Sign up or Login
    def new_user
        new_user = PROMPT.yes?("Would you like to Sign Up?😏".colorize(:green))
        if new_user == true
            signup
        else 
            login
        end
    end

#Helper method that asks User to sign up
    def signup
        username = PROMPT.ask("What's your Username?", required: true)
        @@user = create_user(username)
    end

    def create_user(username)
        User.create(name: username) 
        system 'clear'
    end

def login
    username = PROMPT.ask("Welcome Back!😄 What's your Username?🤔🧐".colorize(:yellow), required: true)
        user = User.find_by(name: username)
        system 'clear'
        if user 
            @@user = user
        else
            PROMPT.error("Sorry Username Not Found!")
            create_user
        end
end

def options 
    selection = PROMPT.select("What would you like to do?") do |option|
        option.choice "Find event by artist", 1
        option.choice "Show my events", 2
        option.choice "Delete an event", 3
        option.choice "Delete account", 4
        option.choice "Exit", 5
    end 

    if selection == 1 
        artist = artist_prompt
        event_list = get_artist_events(artist)
        choose_concert(event_list)
        system 'clear'
        go_back
    elsif 
        selection == 2
        show_my_events 
        sleep(6)
        go_back
    elsif 
        selection == 3 
        delete_event
        puts "Your event was succesfully deleted!"
        go_back
    elsif 
        selection == 4 
        delete_myself 
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

# def event_names 
#     @@user.events.map do |event|
#         Concert.all.find(event.concert_id).name
#     end
# end 

def select_event
    event_name = PROMPT.select("Which event are you looking for?", event_names)
    binding.pry
    Event.find_by(name: "#{event_name}")
#    test = @@user.events.filter do |event|
#         concert_objects.find do |concert_object|
#             event.concert_id == concert_object.id 
#         end 
#     end 
    
          # menu.choice "Go Back to Main Menu"
      # end

       #if event == "Go Back to Main Menu"
       #options
       #end
   
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
    puts "Here are #{@@user.name}'s events!"
    my_event = select_event
    my_event.destroy
    @@user.reload
    binding.pry
    puts "Event Succesfully Deleted!"
    PROMPT.yes?("Would you like to go back?")
    go_back  
end



def go_back
    sleep(2)
    options
end

