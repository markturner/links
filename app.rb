require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'json'

configure do
  # set username
  user = 'markturner'
  
  # feed url
  url = "http://feeds.pinboard.in/rss/u:#{user}/"
  
  # get the feed
  @@feed = open(url)
end

get '/' do
  headers['Cache-Control'] = 'public, max-age=21600' # Cache for six hours
  
  array = []
  
  # use Nokogiri to parse the feed
  doc = Nokogiri::XML(@@feed)
  
  # examine first 5 items (0..4)
  doc.search("item")[0..4].each do |item|
    
    # push items to array
    array << {
      :title => item.search("title").inner_html,
      # had to use the rdf:about attribute for link because hpricot thinks link is a malformed tag!
      :url => item.attribute("about").inner_html,
      :description => item.search("description").inner_text
    }
  end
  
  # return array as json object
  array.to_json

end