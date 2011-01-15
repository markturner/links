require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'hpricot'
require 'open-uri'
require 'json'

configure do
  # set feed url
  url = 'http://feeds.pinboard.in/rss/u:markturner/'
  
  # get the feed
  @@feed = open(url)
end

get '/' do
  array = []
  
  # use Hpricot to parse the feed
  doc = Hpricot.parse(@@feed)
  (doc/:item).each do |item|
    array << {
      :title => item.search("/title").inner_html,
      # had to use the rdf:about attribute for link because hpricot thinks link is a malformed tag!
      :url => item.attributes['rdf:about']
    }
  end
  
  # return array as json object
  array[0..4].to_json

end