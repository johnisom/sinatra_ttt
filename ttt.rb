require 'sinatra'
require 'sinatra/reloader' if development?
require 'tilt/erubis'

require_relative 'lib/game'

configure do
  enable :sessions
  set :session_key, 'secret'
end

before '/play' do
  session[:game] ||= Game.new
  @game = session[:game]
  @board = @game.board
end

helpers do
  def first_row
    @board.squares.values[0...3].each_with_index do |square, idx|
      yield square.marker, idx + 1
    end
  end

  def middle_row
    @board.squares.values[3...6].each_with_index do |square, idx|
      yield square.marker, idx + 4
    end
  end

  def last_row
    @board.squares.values[6...9].each_with_index do |square, idx|
      yield square.marker, idx + 7
    end
  end
end

def flash(message)
  session[:flash] = message
end

get '/' do
  erb :index
end

get '/play' do
  erb :play
end

post '/play' do
  flash("Box #{params[:box]} clicked!")
  @game.human_moves(params[:box].to_i)
  @game.computer_moves
  erb :play
end
