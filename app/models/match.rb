require 'game_type'
require 'doubles'

class Match < ActiveRecord::Base

  include Doubles

  belongs_to :winner, class_name: 'Party'
  belongs_to :p1, class_name: 'Party'
  belongs_to :p2, class_name: 'Party'
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
      unless self.games.count == 1
        self.games.destroy(current_game)
        current_game.update(winner: nil)
        current_game.points.last.destroy
      end
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
      Game.create(match: self) unless self.doubles_match
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
      LastGame.new(self.p1_starts_left, self.p1_first_server, self)
    elsif nth_game % 2 == 1
      OddGame.new(self.p1_starts_left, self.p1_first_server)
    else
      EvenGame.new(self.p1_starts_left, self.p1_first_server)
    end
  end

  def self.start_match(p1_name, p2_name, best_of, 
                       p1_first_server, p1_starts_left,
                       partner_a_name=nil, partner_b_name=nil, 
                       partner_c_name=nil, partner_d_name=nil,
                       p1_id_order=nil, p2_id_order=nil, doubles_match=nil)
    if doubles_match == "true"
      party1 = Party.create(name: partner_a_name + " and " + partner_b_name)
      party2 = Party.create(name: partner_c_name + " and " + partner_d_name)
      Player.create(name: partner_a_name, party: party1)
      Player.create(name: partner_b_name, party: party1)
      Player.create(name: partner_c_name, party: party2)
      Player.create(name: partner_d_name, party: party2)
    else
      party1 = Party.create(name: p1_name)
      party2 = Party.create(name: p2_name)
    end
    match = Match.create(p1: party1, 
                         p2: party2, 
                         best_of: best_of,
                         p1_first_server: p1_first_server,
                         p1_starts_left: p1_starts_left,
                         doubles_match: doubles_match)
    Game.create(match: match, 
                p1_started_game_serving: p1_first_server,
                p1_partners_in_id_order: p1_id_order,
                p1_partners_in_id_order: p2_id_order)
    match
  end
  
  
end
