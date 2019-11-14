require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

get '/' do
  '<a href="https://github.com/johnisom/sinatra_ttt">Github repo</a>'
end
