require 'rubygems'
require 'sinatra'

set :public_folder, 'lib/brine/prompt'

get '/' do
  redirect to("/index.html")
end