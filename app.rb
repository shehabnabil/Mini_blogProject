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

# display the sign-in form
#
get '/sign-in' do 
	erb :sign_in
end

# verify a valid user has signed in
#
post '/sign-in' do 
	# get info from login form and set session data
	user = User.find_by_username(params[:username])
	if user && user.password.password == params[:password]
			session[:user_id] = user.id
			redirect '/show'
	else
		# need to put in flash messages for failed login
		#
		puts "-------------  signin failed ------------------------"				
		redirect 'sign-in'
	end
end 

get '/sign-up' do 
	erb :sign_up 
end 

post '/sign-up' do 
	# get info from login form and set session data
	puts params
	puts "-------------------------------------"
end 

get  '/users' do 
	erb :users
end 

get '/profile' do 
	erb :profile 
end 

get '/blogpost' do 
	@blogpost = Blogpost.find(params[:id])
	erb :blogpost 
end 

put '/blogpost/:id' do 
   @post = Blogpost.find(params[:id])
   if @post.update_attributes(params[:blogpost])
     redirect '/blogpost/#{@blogpost.id}'
   else
     slim :"blogpost/edit"
   end
end

get '/feed' do
	erb :feed 
end 

get '/followers' do 
	erb :followers 
end 

get '/sign-out' do 
	erb :sign_out
end 

get '/show' do
	erb :show
end
get '/edit' do
	erb :edit_profile
end
post '/edit' do
	erb :edit_profile
end

get '/log-out' do
	erb :log_out
end




