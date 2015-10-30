class RenameTables < ActiveRecord::Migration
	def change
		change_column :post, :body, :string, limit: 150
		rename_table :user, :users
		rename_table :post, :posts
		rename_table :profile, :profiles
		rename_table :password, :passwords
	end
end
