require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'

get '/' do
  'Hello world!'
end