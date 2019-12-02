require 'rest-client'
require 'json'
require 'pry'
require 'active_support'
require 'active_support/core_ext'

response_string = RestClient.get('http://web.mta.info/status/serviceStatus.txt')

response = JSON.parse(Hash.from_xml(response_string).to_json)
puts "Enter a train line"
currLookup = gets.chomp
line = response["service"]["subway"]["line"].find{|status| status["name"] == currLookup}
puts line["status"]