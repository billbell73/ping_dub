require 'spec_helper'

describe Match do
  
  it { should belong_to(:winner) }
  it { should belong_to(:p1) }
  it { should belong_to(:p2) }
  it { should have_many(:games) }

  let (:player1) { create(:party) }
  let (:player2) { create(:party) }
  let (:match) { create(:match, p1: player1, 
  	                            p2: player2,
  	                            p1_first_server: true,
  	                            p1_starts_left:true,
  	                            best_of: 3) }

  let (:match2) { create(:match, p1: player1, 
	                               p2: player2,
	                               p1_first_server: false,
                                 p1_starts_left: false,
  	                             best_of: 5) }

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

	context 'miscellaneous methods' do

		it 'can get player' do
			expect(match.get_player 1).to eq player1
		end 

		it 'can be a doubles match or not' do
			expect(match.doubles_match).to eq false
		end

		it 'can tell how many games so far' do
			set_score(7, 11, 6, 2)
			expect(match.nth_game).to eq 2
		end

		it 'can tell max points in game' do
			set_score(7, 11, 6, 2)
			expect(match.max_points).to eq 6
		end

	end

	context 'Incrementing score' do

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

		it 'decrementing a point from 0-0 in 2nd game destroys '\
		      'last point of previous game and deletes winner of previous game' do
			set_score(3, 11, 0, 0)
			match.decrement_score(2)
			expect(match.current_game.player_points(player2)).to equal 10
			expect(match.current_game.winner).to equal nil
		end	

		it 'decrementing score from 0-0 in first game does nothing' do
			set_score(0, 0)
			match.decrement_score(2)
			expect(match.current_game.player_points(player2)).to equal 0
		end

	end

	context 'Identifying server' do

		it 'says player1 serving after 0 points if starts serving' do
			set_score(0,0)
			expect(match.p1_serving?).to equal true
		end

		it 'says player2 serving after 2 points if player1 starts' do
			set_score(0,2)
			expect(match.p1_serving?).to equal false
		end

		it 'says player1 serving after 6 points if player2 started' do
			set_score(4,2,0,0,match2)
			expect(match2.p1_serving?).to equal true
		end

		it 'says player2 serving after 0 points of 2nd game if player1 started' do
			set_score(7, 11, 0, 0)
			expect(match.p1_serving?).to equal false
		end

		it 'says player 2 serving after 4 points of 3rd game if she started' do
			set_score(7, 11, 7, 11, match2)
			increment(4, match2, 1)
			expect(match2.p1_serving?).to equal false
		end

	end

	context 'Identifying when match finished' do

		it 'can tell winning 2 games wins default match' do
			expect(match.games_target).to equal 2
		end

		it 'can tell winning 3 games wins best-of-five match' do
			expect(match2.games_target).to equal 3
		end

	end	

	context 'Switching sides' do

		it 'says player1 on left for 1st game' do
			set_score(1,3)
			expect(match.p1_on_left?).to equal true
		end

		it 'says player1 on right for 2nd game' do
			set_score(5, 11, 6, 0)
			expect(match.p1_on_left?).to equal false
		end

		it 'can tell player side in normal game of 5 game match' do
			set_score(5, 11, 6, 11, match2)
			increment(5, match2, 2)
			expect(match2.p1_on_left?).to equal false
		end

		it 'can tell player side early in last possible game of match' do
			set_score(5, 11, 11, 0)
			increment(3, match, 2)
			expect(match.p1_on_left?).to equal true
		end

		it 'can tell player side late in last possible game of match' do
			set_score(5, 11, 11, 0)
			increment(6, match, 2)
			expect(match.p1_on_left?).to equal false
		end

	end	

	context 'Starting a singles match with passed match choices' do

		it 'can start match' do
			match = Match.start_match('zed', 'ted', 1, false, true)
			expect(match.games.count).to eq 1
			expect(match.current_game.points.count).to eq 0
			expect(match.p1.name).to eq 'zed'
			expect(match.best_of).to eq 1
			expect(match.p1_first_server).to eq false
		end

	end


end
