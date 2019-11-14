# frozen_string_literal: true

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
  @human_score = @game.human.score
  @computer_score = @game.computer.score
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

def flash(message, mode = :neutral)
  session[:flash] = { message: message, mode: mode }
end

def give_encouragement(winner)
  message = case winner
            when :human then Game::WIN_MESSAGES.sample
            when :computer then Game::LOSE_MESSAGES.sample
            when :draw then Game::DRAW_MESSAGES.sample
            end
  flash(message)
end

def handle_logic
  if @game.someone_won_round?
    @game.give_point
    give_encouragement(@game.round_winner)
    @game.reset_round
    redirect '/play'
  elsif @game.draw?
    give_encouragement(@game.round_winner)
    @game.reset_round
    redirect '/play'
  end
end

def play_round(box)
  if @board.unmarked_keys.include? box
    @game.human_moves(box)
    handle_logic
    @game.computer_moves
    handle_logic
  else
    flash('Sorry, you must choose an empty square.', :error)
  end
end

get '/' do
  erb :index
end

get '/play' do
  erb :play
end

post '/play' do
  play_round(params[:box].to_i)
  erb :play
end
