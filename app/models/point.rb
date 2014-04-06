class Point < ActiveRecord::Base

	belongs_to :winner, class_name: 'Player'
	belongs_to :server, class_name: 'Player'
	belongs_to :game

end
