class User < ActiveRecord::Base
	has_one :profile
	has_one :password
	has_many :posts
	has_many :follower_follows, foreign_key: :followee_id, class_name: "Follow"
	has_many :followee_follows, foreign_key: :follower_id, class_name: "Follow"
	has_many :followers, through: :follower_follows
	has_many :followees, through: :followee_follows 
end

class Password < ActiveRecord::Base
	belongs_to :user
end

class Profile < ActiveRecord::Base
	belongs_to :user
end

class Post < ActiveRecord::Base
	belongs_to :user
end

class Follow < ActiveRecord::Base
  belongs_to :follower, class_name: "User", foreign_key: :follower_id
  belongs_to :followee, class_name: "User", foreign_key: :followee_id
end
