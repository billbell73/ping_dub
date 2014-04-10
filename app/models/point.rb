class Point < ActiveRecord::Base

	belongs_to :winner, class_name: 'Party'
	belongs_to :server, class_name: 'Party'
	belongs_to :game

end
