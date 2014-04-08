class Match < ActiveRecord::Base
  belongs_to :winner, class_name: 'Player'
  belongs_to :p1, class_name: 'Player'
  belongs_to :p2, class_name: 'Player'
  has_many :games

  def current_game
  	self.games.last
  end

  def increment_score(point_winner)
    Point.create(winner: point_winner, game: current_game)
    current_game.record_if_won_game(point_winner)
  end

  def games_won(player)
    self.games.where(winner: player).count
  end
  
end
