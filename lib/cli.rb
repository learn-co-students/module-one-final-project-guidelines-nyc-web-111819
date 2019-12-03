@@user = nil
@@concert = nil

def run
    welcome
end

#welcome
def welcome
    puts "Welcome to Music Source"
    puts "Input name"
    create_user
    get_artist_events
    create_event
    show_my_events
end

#login to get username
def create_user
    user_name = gets.chomp
    @@user = User.create(name: "#{user_name}") 
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
    
    @@concert = events_hash["resultsPage"]["results"]["event"][0]["displayName"]
     
    #map through and get array of display name for event
    event_array = events_hash["resultsPage"]["results"]["event"].map do |event|
        event["displayName"]
    end 
end 

#get user input of event selection
#set @@concert to something

#create event (argument is the user's selection)
def create_event
    new_concert = Concert.create(name: "#{@@concert}")
    new_event = Event.create(user_id: "#{@@user.id}", concert_id: "#{new_concert.id}")
    
end 

def show_my_events 
    Event.all.each do |event|
        if event.user_id == @@user.id 
            puts Concert.find(event.concert_id).name
        end 
    end 
end 





