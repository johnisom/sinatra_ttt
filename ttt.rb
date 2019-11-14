require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

configure do
  enable :sessions
  set :session_key, 'secret'
end

get '/' do
  erb :index
end

get '/play' do
  erb :play
end

post '/play' do
  session[:flash] = "Button #{params[:box]} clicked!"
  erb :play
end
