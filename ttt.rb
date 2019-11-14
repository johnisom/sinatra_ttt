require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

get '/' do
  'home page for tic tac toe'
end
