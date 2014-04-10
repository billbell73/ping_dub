class Player < ActiveRecord::Base

	has_many :points
	has_many :games
	has_many :matches
	belongs_to :party

end
