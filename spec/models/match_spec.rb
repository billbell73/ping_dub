require 'spec_helper'

describe Match do
  
  it { should belong_to(:winner) }
  it { should belong_to(:p1) }
  it { should belong_to(:p2) }
  it { should have_many(:games) }

  let (:player1) { create(:player) }
  let (:player2) { create(:player) }
  let (:match) { create(:match, p1: player1, 
  	                            p2: player2,
  	                            p1_first_server: true) }

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

	context 'Decrementing score' do

		it 'can decrement a player\'s score mid-game' do
			set_score(4, 7)
			match.decrement_score(1)
			expect(match.current_game.player_points(player2)).to equal 7
			expect(match.current_game.player_points(player1)).to equal 3
		end

		it 'decrementing player 2 score at 7-0 in game leaves score unchanged' do
			set_score(3, 11, 7, 0)
			match.decrement_score(2)
			expect(match.current_game.player_points(player2)).to equal 0
		end

		it 'initial decrement from 0-0 in 2nd game makes current game first game' do
			set_score(3, 11, 0, 0)
			expect(match.games.count).to equal 2
			match.decrement_score(2)
			expect(match.games.count).to equal 1
		end

		it 'decrementing 2 points from 0-0 in 2nd game reduces '\
																				'player\'s 1st game score by 1' do
			set_score(3, 11, 0, 0)
			match.decrement_score(2)
			expect(match.current_game.player_points(player2)).to equal 11
			match.decrement_score(2)
			expect(match.current_game.player_points(player2)).to equal 10
			expect(match.current_game.winner).to equal nil
		end	

	end

	context 'Identifying server' do

		let (:match2) { create(:match, p1_first_server: false) }

		it 'says player1 serving after 0 points if starts serving' do
			expect(match.p1_serving?(1,0)).to equal true
		end

		it 'says player2 serving after 2 points if player1 starts' do
			expect(match.p1_serving?(1,2)).to equal false
		end

		it 'says player1 serving after 6 points if player2 started' do
			expect(match2.p1_serving?(1,6)).to equal true
		end

		it 'says player2 serving after 0 points of 2nd game if player1 started' do
			expect(match.p1_serving?(2,0)).to equal false
		end

		it 'says player 2 serving after 4 points of 3rd game if she started' do
			expect(match2.p1_serving?(3,4)).to equal false
		end

	end

end
