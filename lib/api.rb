require 'rest-client'
require 'json'
require 'pry'
require 'active_support'
require 'active_support/core_ext'
require 'active_record'

def sorting_api_data
    response_string = RestClient.get('http://web.mta.info/status/serviceStatus.txt')
    response = JSON.parse(Hash.from_xml(response_string).to_json)
    lineHash = {}
    response["service"]["subway"]["line"][0..-2].each do |line|
        line["name"].split("").each{|route| lineHash[route] = line["status"]}
    end
    
    lineHash.each do |key, value|
        Line.create(train_name: key, status: value)
    end
    
end