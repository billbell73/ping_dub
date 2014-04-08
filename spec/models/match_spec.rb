require 'spec_helper'

describe Match do
  
  it { should belong_to(:winner) }
  it { should belong_to(:p1) }
  it { should belong_to(:p2) }
  it { should have_many(:games) }

  let (:player1) { create(:player) }
  let (:player2) { create(:player) }
  let (:match) { create(:match)}
  let (:game1) { create(:game, match: match ) }
  let (:game2) { create(:game, match: match ) }

	def set_score(p1_game1, p2_game1, p1_game2=0, p2_game2=0, match=match)
		increment(p1_game1, game1, match, player1)
		increment(p2_game1, game1, match, player2)
	end

	def increment(points, game, match, player)
		points.times{ match.increment_score(player) }
	end

	it 'can be a doubles match or not' do
		expect(match.doubles_match).to eq false
	end

	it 'can increment score' do
		increment(2, game1, match, player1)
		expect(game1.player_points(player1)).to eq 2
	end

	it 'can tell how many games a player has won' do
		set_score(7, 11)
		expect(match.games_won(player2)).to equal 1
		expect(match.games_won(player1)).to equal 0
	end

end
