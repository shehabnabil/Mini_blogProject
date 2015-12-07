require 'bundler/setup'
require 'sinatra' 
require 'sinatra/activerecord'
require './models.rb'
require 'rack-flash'
require 'pp.rb'

enable :sessions
use Rack::Flash, :sweep => true

#
#
configure(:development){set :database, "sqlite3:groupDB.sqlite3"}

def current_user 
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	else
		@current_user = nil
	end 
	puts "-------------- current user just changed to user with id #{session[:user_id]}"
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
			current_user
			redirect '/show'
	else
		# need to put in flash messages for failed login
		#
		flash[:notice] = "Signin failed. Please try again"				
		redirect 'sign-in'
	end
end 

# generate user login form
#
get '/sign-up' do 
	erb :sign_up 
end 

# generate user sign-up form
#
post '/sign-up' do 
	# get info from login form and set session data
	#
	user = User.create(	
		fname:params[:fname],
		lname:params[:lname],
		username:params[:username]
	)
	if user
		password = Password.create(user_id:user.id, 
											password:params[:password])
		if password
			profile = Profile.create(
				country:params[:country],
				picture_path:params[:picture_path],
				post_picture_path:params[:post_picture_path]
			) 
			if profile
				redirect '/sign-in'
			else
				flash[:notice] = "Profile creation failed. Please fill in your profile information."
				redirect '/edit'
			end
		else
			flash[:notice] = "Password creation failed. Please try again."
			redirect '/sign-up'
		end
	else 
		flash[:notice] = "New Member creation failed. Please try again."
		redirect '/sign-up'
	end
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
	puts "current user is----------------"
	pp @current_user
	puts "--------------------------------------"
	erb :show
end
get '/edit' do
	erb :edit_profile
end
post '/edit' do
	erb :edit_profile
end

get '/log-out' do
	session[:user_id] = nil
	current_user
	flash[:notice] = "You have logged out."
	redirect '/'
end




