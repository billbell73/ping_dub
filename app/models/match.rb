class Match < ActiveRecord::Base
  belongs_to :winner, class_name: 'Player'
  belongs_to :p1, class_name: 'Player'
  belongs_to :p2, class_name: 'Player'
  has_many :games

  def increment_score(player)
  	Point.create(winner: player, game: current_game)
  end

  def current_game
  	self.games.last
  end
  
end
