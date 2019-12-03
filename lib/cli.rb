PROMPT = TTY::Prompt.new

@@user = nil
@@concert_name = nil

def run
    welcome
end

#welcome
def welcome
    puts "Welcome to Music Source"
    create_user
    options
    get_artist_events
    binding.pry
end

#login to get username
def create_user
    puts "Input name:"
    user_name = gets.chomp
    @@user = User.create(name: "#{user_name}") 
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
        get_artist_events
        sleep(2)
        options
    elsif 
        selection == 2
        show_my_events 
        sleep(2)
        options
    elsif 
        selection == 3 
        puts "You just deleted your event!"
        sleep(2)
        options
        #delete_event
    elsif 
        selection == 4 
        delete_myself 
        sleep(2)
        options
    end
end 

#get artist input from user 
def get_artist_events
    puts "Input your favorite artist:"
    user_input = gets.chomp 
    #get artist id
    artist_string = RestClient.get("https://api.songkick.com/api/3.0/search/artists.json?apikey=io09K9l3ebJxmxe2&query=#{user_input}")
    artist_hash = JSON.parse(artist_string)
    artist_id = artist_hash["resultsPage"]["results"]["artist"][0]["id"]

    #look at Songkick and find list of events in a timeframe we set with that particular artist
    events_string = RestClient.get("https://api.songkick.com/api/3.0/artists/#{artist_id}/calendar.json?apikey=io09K9l3ebJxmxe2
     ")
    events_hash = JSON.parse(events_string)
    
    # @@concert_name = events_hash["resultsPage"]["results"]["event"][0]["displayName"]
     
    #map through and get array of display name for event
    event_array = events_hash["resultsPage"]["results"]["event"].map do |event|
        event["displayName"]
    end 

    selection = PROMPT.select("Choose your concert?", event_array)
    new_concert = Concert.create(name: "#{selection}")
    new_event = Event.create(user_id: "#{@@user.id}", concert_id: "#{new_concert.id}")
    puts "You just saved an event!"
    
end 

def show_my_events 
    Event.all.each do |event|
        if event.user_id == @@user.id
            puts Concert.find(event.concert_id).name
        end 
    end 
end 

def destroy_all_users
    User.all.each do |user|
        user.destroy 
    end 
end 

def delete_myself
    @@user.destroy
end 

# def delete_event(event)

# end 



