require 'rgeo'
require 'rest-client'
require 'json'
#require 'active_support'
#require 'active_support/core_ext'
#require 'active_record'
require 'cgi'
require 'nokogiri'
require 'geocoder'
require_relative '../config/environment'

def station_by_location(query)
    api_ingest = RestClient.get('https://data.cityofnewyork.us/resource/kk4q-3rt2.json')
    query.gsub!(" ", "%20")
    query = query+"%20NYC,%20NY,%20USA"
    api2_ingest = RestClient.get("http://dev.virtualearth.net/REST/v1/Locations?query=#{query}&maxResults=1&key=#{ENV['APIBING']}")
    cleanData = JSON.parse(api_ingest)
    myLoc = JSON.parse(api2_ingest)["resourceSets"][0]["resources"][0]["geocodePoints"][0]["coordinates"]
    myLoc.reverse!
    array = cleanData.map{|datapoint| {Geocoder::Calculations.distance_between(datapoint["the_geom"]["coordinates"], myLoc) => datapoint}}
    closestStations =  array.sort_by{|arrayElement| arrayElement.keys[0]}[0]
    closestStation = closestStations[closestStations.keys[0]]
    stationCoords = {"geometry" => {"x" => closestStation["the_geom"]["coordinates"][0], "y" => closestStation["the_geom"]["coordinates"][1], "spatialReference" => {"wkid" => "4326"}},"attributes" => {"Name" => closestStation["name"]}}
    currLocationCoords =  myLoc
    currLocation = {"features" => [{"geometry"=> {"x"=> currLocationCoords[0],"y" => currLocationCoords[1], "spatialReference"=> {"wkid" => "4326"}},"attributes"=> {"Name"=> query.gsub!("%20"," ")}},stationCoords]}
    apiCall = currLocation.to_s.gsub!("=>",":")
    directionsTo = RestClient.post("https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World/solve", {'token': ENV['ARCGIS'], 'stops': apiCall,'f': 'json'})
    json = JSON.parse(directionsTo)["directions"][0]["features"][1..].map{|direction| direction["attributes"]["text"]}
    lines = closestStation["line"]
    possibleLines = ["4","5","6","E","M","J","1","2","3","7","A","C","B","D","F","G","Z","L","N","Q","R","W","S"]
    lines = lines.split(" ")[0]
    lines = lines.split("")
    lines = lines.select{|line| possibleLines.include?line}
    lines = lines.uniq
    linestring = lines.join("")
    linestring = [closestStation["name"],linestring.gsub(/[[:punct:]]/, ''), json]
    linestring
end

station_by_location("Times Square")