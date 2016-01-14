require 'bundler/setup'
require 'sinatra' 
require 'sinatra/activerecord'
require './models.rb'
require 'rack-flash'
require 'pp.rb'
require 'pry'

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

	return @current_user
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
			redirect "/show?u=#{user.id}"
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

#
#  Display all users in the system with a link to their page
#
get  '/users' do 
	@users = User.all
	erb :users
end 

#
#  Display a specific user's posts
#
get '/show' do
	@show_user = User.find(params[:u].to_i)
	@posts = Post.where(:user_id => @show_user)

	# check and set if show_user is currently following current_user
	@following = []
	if current_user
		@following = Follow.where(:follower_id => current_user, :followee_id => @show_user)
	end
	erb :show
end
#
#  set up following from the show user page
#
get '/show_follow' do
	@show_user = User.find(params[:ee].to_i)
	#
	# check that follower is not already following
	#
	following = Follow.create(:follower_id => current_user.id, :followee_id => @show_user.id)
	if !following
		flash[:alert] = "Sorry, you cannot follow #{@show_user.username} at this time."
	end
	redirect back
end
#
#  set up UNfollowing from the show user page
#
get '/show_unfollow' do
	@show_user = User.find(params[:ee].to_i)
	#
	# check that follower is not already following
	#
	following = Follow.where(:follower => current_user.id, :followee => @show_user.id)
	if following.length > 0
		following[0].destroy
	else
		flash[:alert] = "Sorry, you cannot unfollow #{@show_user.username} at this time."
	end
	redirect back
end
#
#  show, edit, and create individual posts
#
get '/blogpost_show' do 
	@post = Post.find(params[:p])
	@show_user = User.find(@post.user_id)
	puts "-----------------------------"
	puts @post.user
	puts "-----------------------------"
	# check and set if show_user is currently following current_user
	@following = []
	if current_user
		@following = Follow.where(:follower_id => current_user, :followee_id => @show_user)
	end
	erb :blogpost_show
end 

get '/blogpost_edit' do 
	@post = Post.find(params[:p])
	erb :blogpost_edit
end 

post '/blogpost_edit' do 
  blogpost = Post.find(params[:p])
   if blogpost.update_attributes(title: params[:title], body: params[:body])
		redirect "/show?u=#{current_user.id}"
   else
		flash[:alert] = "Sorry, post edit failed. Please try again."
		redirect "/show?u=#{current_user.id}"
   end
end

get '/blogpost_new' do 
	erb :blogpost_new
end 

post '/blogpost_new' do 

	post = Post.create(
		:user_id => current_user.id, 
		:title => params[:title], 
		:body => params[:body], 
		:date_posted => DateTime.now
	)

	if post
		redirect "/show?u=#{current_user.id}"
	else
		flash[:alert] = "Sorry, new post failed. Please try again."
		redirect "/show?u=#{current_user.id}"
	end
end 

get '/feed' do
	erb :feed 
end 

get '/followers' do 
	erb :followers 
end 

get '/sign-out' do 
	session[:user_id] = nil
	current_user
	flash[:notice] = "You have logged out."
	redirect '/'
end 
#
#  show and edit profiles
#
get '/profile' do 
	erb :profile 
end 
get '/edit' do
	erb :edit_profile
end
post '/edit' do
	erb :edit_profile
end





