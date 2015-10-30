require 'bundler/setup'
require 'sinatra' 
require 'sinatra/activerecord'
require './models.rb'
require 'rack-flash'

enable :sessions
use Rack::Flash, :sweep => true

set :database, "sqlite3:groupDB.sqlite3"

def current_user 
	if session[:user_id]
		@current_user =User.find(session[:user_id])
	end 
end 

# views 
get '/' do 
	erb :home 
end 

get '/sign-in' do 
	erb :sign-in
end

post '/sign-in' do 
	erb :sign-in
end 

get 'sign-up' do 
	erb :sign-up 
end 

post 'sign-up' do 
	erb :sign-up 
end 

get  '/users' do 
	erb :users
end 

get '/profile' do 
	erb :profile 
end 

get '/blogpost' do 
	erb :blogpost 
end 

get '/feed' do
	erb :feed 
end 

get '/followers' do 
	erb :followers 
end 

get '/sign-out' do 
	erb :sign-out
end 
