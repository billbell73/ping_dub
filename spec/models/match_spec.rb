require 'spec_helper'

describe Match do
  
  it { should belong_to(:winner) }
  it { should belong_to(:p1) }
  it { should belong_to(:p2) }
  it { should have_many(:games) }

  let (:player1) { create(:player) }
  let (:player2) { create(:player) }
  let (:match) { create(:match, p1: player1, p2: player2)}

	def set_score(p1_game1, p2_game1, p1_game2=0, p2_game2=0, match=match)
		create(:game, match: match)
		increment(p1_game1, match, 1)
		increment(p2_game1, match, 2)
		increment(p1_game2, match, 1)
		increment(p2_game2, match, 2)
	end

	def increment(points, match, player)
		points.times{ match.increment_score(player) }
	end

	it 'can get player' do
		expect(match.get_player 1).to eq player1
	end 

	it 'can be a doubles match or not' do
		expect(match.doubles_match).to eq false
	end

	it 'can increment score' do
		game1 = create(:game, match: match)
		increment(2, match, 1)
		expect(game1.player_points(player1)).to eq 2
	end

	it 'can tell how many games a player has won' do
		set_score(7, 11)
		expect(match.games_won(player2)).to equal 1
		expect(match.games_won(player1)).to equal 0
	end

	it 'can complete games and start new games' do
		set_score(7, 11, 11, 6)
		expect(match.games_won(player2)).to equal 1
		expect(match.games_won(player1)).to equal 1
	end

	it 'knows when match won' do
		set_score(7, 11, 6, 11)
		expect(match.winner).to eq player2
	end

end
