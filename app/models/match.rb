require 'game_type'

class Match < ActiveRecord::Base
  belongs_to :winner, class_name: 'Player'
  belongs_to :p1, class_name: 'Player'
  belongs_to :p2, class_name: 'Player'
  has_many :games

  attr_reader :game_just_won_by

  def current_game
  	self.games.last
  end

  def nth_game
    self.games.count
  end

  def increment_score(player_number)
    point_winner = get_player player_number.to_i
    Point.create(winner: point_winner, game: current_game)
    @game_just_won_by = nil
    if current_game.record_if_won_game(point_winner)
      finish_game(point_winner)
    end
  end

  def decrement_score(player_number)
    point_winner = get_player player_number.to_i
    point = Point.where(winner: point_winner, game: current_game).last
    if current_game.total_points != 0
      current_game.points.destroy(point) if point
    else
      self.games.destroy(current_game)
      current_game.update(winner: nil)
      current_game.points.last.destroy
    end
  end

  def get_player number
    return self.p1 if number == 1
    return self.p2 if number == 2
  end

  def finish_game(point_winner)
    if games_won(point_winner) == games_target
      self.update(winner: point_winner)
    else
      @game_just_won_by = current_game.winner.name
      Game.create(match: self)
    end
  end

  def games_won(player)
    self.games.where(winner: player).count
  end

  def p1_serving?
    game_type(nth_game).p1_serving?(current_game.total_points)
  end

  def max_points
    [current_game.player_points(get_player 1), 
     current_game.player_points(get_player 2)].max
  end

  def p1_on_left?
    game_type(nth_game).p1_on_left?(max_points)
  end

  def games_target
    (self.best_of / 2) + 1
  end

  def game_type(nth_game)
    if nth_game == self.best_of
      LastGame.new(self.p1_starts_left, self.p1_first_server)
    elsif nth_game % 2 == 1
      OddGame.new(self.p1_starts_left, self.p1_first_server)
    else
      EvenGame.new(self.p1_starts_left, self.p1_first_server)
    end
  end

  def self.start_match(p1_name, p2_name, best_of=3, 
                       p1_first_server=true, p1_starts_left=true)
    player1 = Player.create(name: p1_name)
    player2 = Player.create(name: p2_name)
    match = Match.create(p1: player1, 
                         p2: player2, 
                         best_of: best_of,
                         p1_first_server: p1_first_server,
                         p1_starts_left: p1_starts_left)
    Game.create(match: match)
    match
  end
  
  
end
