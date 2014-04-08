class Game < ActiveRecord::Base
  belongs_to :winner, class_name: 'Player'
  belongs_to :match

  has_many :points

  def player_points(player)
  	self.points.where(winner: player).count
  end

  def opponent_points(player)
  	self.points.where.not(winner: player).count
  end

  def two_ahead?(player)
		player_points(player) == opponent_points(player) + 2
	end

  def record_if_won_game(player)
		if (player_points(player) == 11 && opponent_points(player) <= 9) || 
				(opponent_points(player) > 10 && two_ahead?(player))
			self.update(winner: player)
		end
	end



end
