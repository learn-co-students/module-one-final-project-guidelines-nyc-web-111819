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

#look at Songkick and find list of events in a timeframe we set with that particular artist
response_string = RestClient.get('https://api.songkick.com/api/3.0/metro_areas/7644/calendar.json?apikey=io09K9l3ebJxmxe2
')
response_hash = JSON.parse(response_string)

events = response_hash["resultsPage"]["results"]["event"].select do |event|
    event["performance"][0]["displayName"] == user_input 
end


puts "HELLO WORLD"
