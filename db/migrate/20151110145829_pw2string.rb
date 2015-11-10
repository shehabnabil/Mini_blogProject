class Pw2string < ActiveRecord::Migration
	def change
		change_table(:passwords) do |t|
			t.column :password, :string
		end
	end
end
