require 'rubygems'
require 'sinatra'

set :public_folder, 'lib/brine/prompt'
before do
  cache_control :public, :must_revalidate, max_age: 0
end

get '/' do
  redirect to("/index.html")
end