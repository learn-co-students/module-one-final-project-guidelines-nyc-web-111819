require 'rest-client'
require 'json'
require 'pry'
require 'active_support'
require 'active_support/core_ext'
require 'active_record'
require 'cgi'
require 'nokogiri'
def sorting_api_data
    Thread.new do
        loop do
            Line.destroy_all
            response_string = RestClient.get('http://web.mta.info/status/serviceStatus.txt')
            response = JSON.parse(Hash.from_xml(response_string).to_json)
            response["service"]["subway"]["line"][0..-2].each do |line|
                if line["text"] == nil
                    line["name"].split("").each{|indiv| Line.create(train_name: indiv, status: line["status"], elaborate: "N/A")}
                else
                    line["text"] = line["text"].gsub("<br clear=left>"," ")
                    elaboration = Nokogiri::HTML(CGI.unescapeHTML(line["text"])).content.squish
                    line["name"].split("").each{|indiv| Line.create(train_name: indiv, status: line["status"], elaborate: elaboration)}
                end
            end
            sleep(300)
        end
    end
end