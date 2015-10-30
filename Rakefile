require 'sinatra/activerecord/rake' 
require './app.rb'

create_table :User do |t|
	t.string :fname
	t.string :lname
	t.string :username
	t.string :email
	t.datetime :join_date
	t.string :country
	t.string :picture_path
	t.string :post_picture_path
end

create_table :Password do |t|
	t.integer :user_id
	t.integer :password
end

create_table :Post do |t|
	 t.string :title
	 t.string :body
	 t.integer :user_id
	 t.datetime :date_osted
	 t.string :favorites
end

create_table :UserFollows do |t|
	 t.integer :followed_id
	 t.integer :follower_id
end

create_table :ExtFollowers do |t|
	t.integer :followed_id
	t.string :follower
end
