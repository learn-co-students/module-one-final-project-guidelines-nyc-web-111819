require_relative '../config/environment'
require 'rest-client'
require 'json'
require 'pry'

#welcome
puts "Welcome to music source"
puts "Input name"

#login to get username
gets.chomp 

#create a user

puts "Input your favorite artist:"
#get artist
user_input = gets.chomp 

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

binding.pry
puts "HELLO WORLD"
