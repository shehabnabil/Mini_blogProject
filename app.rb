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
	@posts = Post.first(10) 

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
			profile = Profile.create(country:params[:country])
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
get '/users' do 
	@users = User.all
	erb :users
end 

get '/user_delete' do
	erb :user_delete
end

post '/user_delete' do
	# delete any follower-records where I follow
	records = Follow.where(follower_id: current_user.id)
	records.each do |record|
		record.destroy
	end

	# delete any follower-records where I'm followed
	records = Follow.where(followee_id: current_user.id)
	records.each do |record|
		record.destroy
	end

	# delete all my posts
	records = Post.where(user_id: current_user.id)
	records.each do |record|
		record.destroy
	end

	# delete my profile
	records = Profile.where(user_id: current_user.id)
	records.each do |record|
		record.destroy
	end

	# delete me as a user
	records = User.where(id: current_user.id)
	records.each do |record|
		record.destroy
	end

	redirect '/sign-out'
end
#
#  Display a specific user's posts
#
get '/show' do
	@show_user = User.find(params[:u].to_i)

	post_users = [@show_user.id]

	# if current_user is viewing their own page, their feed will
	# be a mix of their own and their followee's posts
	@following = []
	if current_user
		@following = Follow.where(:follower_id => @show_user.id)
		if @following.length > 0
			# add followed posts to the list of posts to show
			@following.each do |follows|
				# unsorted_posts.append Post.where(user_id: follows.followee_id)
				post_users << follows.followee_id
			end
		end
	end

	# get all posts from show_user and followees
	#
	@posts = Post.where(:user_id => post_users)

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

get '/sign-out' do 
	session[:user_id] = nil
	current_user
	flash[:notice] = "You have logged out."
	redirect '/'
end 
#
#  edit profiles
#

get '/profile_edit' do
	@profile = nil
	if current_user
		if current_user.profile
			@profile = current_user.profile
		else
			@profile = Profile.new(user_id: current_user.id)
		end
	else
		@profile = Profile.new(user_id: current_user.id)
	end

	erb :profile_edit
end

post '/profile_edit' do
	profile = Profile.where(:user_id => current_user.id)
	if profile.length > 0
		if profile[0].update_attributes(country: params[:country])
			flash[:notice] = "Profile updated."	
			redirect '/profile'
		else
			flash[:notice] = "Profile update failed. Please try again"	
			redirect '/profile_edit'
		end
	else
		profile.create(
			user_id: current_user.id,
			country: params[:country]
		)
	end
	erb :profile
end





