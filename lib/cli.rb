def run
    welcome
    create_user
end


def welcome
#welcome
puts "Welcome to Music Source"
puts "Input name"
end

def create_user
#login to get username
user_name = gets.chomp
User.create(name: "#{user_name}") 
end

def get_artist
puts "Input your favorite artist:"
#get artist
user_input = gets.chomp
end 

#get artist id
artist_string = RestClient.get("https://api.songkick.com/api/3.0/search/artists.json?apikey=io09K9l3ebJxmxe2&query=#{user_input}")
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

