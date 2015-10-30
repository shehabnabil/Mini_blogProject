require 'sinatra/activerecord/rake' 
require './app.rb'

create_table :User do |t|
	integer :user_id 
	t.string :fname
	t.string :lname
	t.string :username
	t.string :email
	datetime :join_date
	t.string :country
	t.string :hobbies
end

create_table :Password do |t|
integer :id PK
integer :user_id FK
integer :password

create_table :Post do |t|
 t.string :title
 t.string :body
 integer :user_id FK
 datetime :datePosted
 t.string :favorites (vote/favorite/like count)

create_table :UserFollows do |t|
 integer :id PK
 integer :followed_id FK
 integer :follower_id FK
