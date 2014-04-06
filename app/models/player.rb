class Player < ActiveRecord::Base

	has_many :points
	has_many :games

end
