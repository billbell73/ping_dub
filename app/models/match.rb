class Match < ActiveRecord::Base
  belongs_to :winner, class_name: 'Player'
  belongs_to :p1, class_name: 'Player'
  belongs_to :p2, class_name: 'Player'
  has_many :games

  def current_game
  	self.games.last
  end

  def increment_score(player_number)
    point_winner = get_player player_number.to_i
    Point.create(winner: point_winner, game: current_game)
    if current_game.record_if_won_game(point_winner)
      finish_game(point_winner)
    end
  end

  def get_player number
    return self.p1 if number == 1
    return self.p2 if number == 2
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
