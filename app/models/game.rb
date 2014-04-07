class Game < ActiveRecord::Base
  belongs_to :winner, class_name: 'Player'
  belongs_to :match

  has_many :points

  def player_points(player)
  	self.points.where(winner: player).count
  end


end
