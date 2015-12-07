class CreateTables < ActiveRecord::Migration
	def change
		create_table :user do |t|
			t.string :fname
			t.string :lname
			t.string :username
			t.datetime :join_date
		end

		create_table :profile do |t|
			t.string :country
			t.string :picture_path
			t.string :post_picture_path
			t.integer :user_id
		end

		create_table :passwords do |t|
			t.integer :user_id
			t.string :password
		end

		create_table :post do |t|
			 t.string :title
			 t.string :body
			 t.integer :user_id
			 t.datetime :date_posted
			 t.integer :favorites
		end

		create_table :follows do |t| 
			t.integer :follower_id
			t.integer :followee_id
		end 
	end
end

