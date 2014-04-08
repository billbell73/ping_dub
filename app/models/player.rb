class Player < ActiveRecord::Base

	has_many :points
	has_many :games
	has_many :matches

end
