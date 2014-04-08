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
    if current_game.record_if_won_game(point_winner)
      finish_game(point_winner)
    end
  end

  def finish_game(point_winner)
    if games_won(point_winner) == 2
      self.update(winner: point_winner)
    else
      Game.create(match: self)
    end
  end

  def games_won(player)
    self.games.where(winner: player).count
  end
  
end
