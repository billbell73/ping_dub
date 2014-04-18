require 'spec_helper'

describe 'Matches API' do

	def increment_score(player_number, match)
	  patch api_match_path(match), { p_number: player_number } 
	  @response, @json = response, JSON.parse(response.body)
	end

	def decrement_score(player_number, match)
    patch api_match_path(match), { p_number: player_number, decrement: true } 
		@response, @json = response, JSON.parse(response.body)
  end

  context 'updating singles match' do

		let(:player1) { create(:party, name: 'Gee') }
		let(:player2) { create(:party, name: 'Zob') }
		let(:singles_match) { create(:match, p1: player1, 
		                             p2: player2,
		                             p1_first_server: true,
	                               p1_starts_left: true,
	  	                           best_of: 5) }

		before do
			create(:game, match: singles_match)
		end

		it 'returns a success status code' do
		  increment_score(1, singles_match)
		  expect(@response).to be_success
		end

		it 'can increment score for a player' do
		  expect { increment_score(1, singles_match) }.to change{ singles_match.current_game.
		                                            player_points(player1) }.by(1)
		end

		it 'can decrement score for a player' do
	    5.times{increment_score(1, singles_match)}
	    expect { decrement_score(1, singles_match) }.to change { singles_match.current_game.
			                                           player_points(player1) }.by(-1)
	  end

		it 'returns current state of game' do
	    5.times{increment_score(1, singles_match)}
	    11.times{increment_score(2, singles_match)}
	    4.times{increment_score(1, singles_match)}
	    expect(@json['p1points']).to eq 4
	    expect(@json['p2points']).to eq 0
	    expect(@json['p1games']).to eq 0
	    expect(@json['p2games']).to eq 1
	    expect(@json['isP1Left']).to eq false
	    expect(@json['isP1Serving']).to eq false
	    expect(@json['p2name']).to eq 'Zob'
	  end

	  it 'returns match winner name when match won' do
	    32.times{increment_score(1, singles_match)}
	    expect(@json['matchWinner']).to eq nil
	    increment_score(1, singles_match)
	    expect(@json['matchWinner']).to eq 'Gee'
	  end

	  it 'returns game winner name when game just won' do
	    10.times{increment_score(1, singles_match)}
	    expect(@json['gameJustWonBy']).to eq nil
	    increment_score(1, singles_match)
	    expect(@json['gameJustWonBy']).to eq 'Gee'
	    increment_score(1, singles_match)
	    expect(@json['gameJustWonBy']).to eq nil
	  end

	end

  context 'Starting a new match' do

	  it 'will start new game on receipt of post request' do
	  	post api_matches_path, { p1_name: 'Geoff', p2_name: 'Mel' } 
			@response, @json = response, JSON.parse(response.body)
			match = Match.find(@json['match_id'])
			expect(match.p2.name).to eq 'Mel'
	  end

		it 'will initiate a singles match with appropriate match choices' do
	  	post api_matches_path, { p1_name: 'Geoff', 
			                         p2_name: 'Mel',
			                         best_of: 5,
			                         p1_first_server: false,
			                         p1_starts_left: false } 
			@response, @json = response, JSON.parse(response.body)
			match = Match.find(@json['match_id'])
			expect(match.best_of).to eq 5
			expect(match.p1_first_server).to eq false
			expect(match.p1_starts_left).to eq false
	  end

		it 'will initiate a doubles match with appropriate match choices' do
	  	post api_matches_path, {
			                         best_of: 3,
			                         p1_first_server: false,
			                         p1_starts_left: false,
			                         partner_a_name: 'a',
			                         partner_b_name: 'b',
			                         partner_c_name: 'c',
			                         partner_d_name: 'd',
			                         p1_partners_in_id_order: false,
			                         p2_partners_in_id_order: false,
			                         doubles_match: true } 
			@response, @json = response, JSON.parse(response.body)
			match = Match.find(@json['match_id'])
			expect(match.best_of).to eq 3
			expect(match.p2.name).to eq 'c and d'
			expect(match.p2.players.first.name).to eq 'c'
			expect(match.current_game.p1_partners_in_id_order).to eq false
	  end

	end

	context 'updating doubles match' do

		let (:party1) { create(:party, name: 'a and b')}
		let (:party2) { create(:party, name: 'c and d')}
	  let (:doubles_match) { create(:match, doubles_match: true,
  	                                      p1: party1, 
	                            	          p2: party2,
	                            	          p1_first_server: true,
	                            	          p1_starts_left: true,
	                            	          best_of: 5) }

	  before do
	  	create(:player, name: 'a', party: party1) 
	  	create(:player, name: 'b', party: party1) 
	  	create(:player, name: 'c', party: party2) 
	  	create(:player, name: 'd', party: party2)

	  	create(:game, match: doubles_match,
			              p1_started_game_serving: true,
			              p1_partners_in_id_order: true,
			              p2_partners_in_id_order: true)
		end

		context 'within game' do

			it 'returns a success status code' do
			  increment_score(1, doubles_match)
			  expect(@response).to be_success
			end

			it 'can increment score for a pair' do
			  expect { increment_score(1, doubles_match) }.to change{ doubles_match.current_game.
			                                            player_points(party1) }.by(1)
			end

			it 'can decrement score for a pair' do
		    5.times{ increment_score(1, doubles_match) }
		    expect { decrement_score(1, doubles_match) }.to change { doubles_match.current_game.
				                                           player_points(party1) }.by(-1)
		  end

		  it 'returns details for pairs' do
		  	increment_score(1, doubles_match)
		    expect(@json['isP1Left']).to eq true
		    expect(@json['isP1Serving']).to eq true
		  end

		  it 'returns who involved in first shot of point' do
		  	increment_score(1, doubles_match)
		  	expect(@json['p1PartnerUpFirst']).to eq 'a'
		  	expect(@json['p2PartnerUpFirst']).to eq 'c'
		  	expect(@json['p1PartnerUpSecond']).to eq 'b'
		  	expect(@json['p2PartnerUpSecond']).to eq 'd'
		  end

		end

		context 'at end of a game' do

			it 'at game end offers potential next servers' do
				5.times{increment_score(1, doubles_match)}
		    11.times{increment_score(2, doubles_match)}
		    expect(@json['nextServerAName']).to eq 'c'
		    expect(@json['nextServerBName']).to eq 'd'
		  end

		end

	  context 'new game, after server and receiver chosen' do

		  before do
		  	5.times{increment_score(1, doubles_match)}
		    11.times{increment_score(2, doubles_match)}
	  		patch api_match_path(doubles_match), 
		          { nextServer: doubles_match.p2.players.first.id }
		    increment_score(1, doubles_match)
	  	end

			it 'starts new game on being given next server choice' do
		    expect(@json['p1points']).to eq 1
		    expect(@json['p2games']).to eq 1
		  end

			it 'knows which partner serving second point of new game' do
		    expect(@json['p2PartnerUpFirst']).to eq 'c'
		    expect(@json['p2PartnerUpSecond']).to eq 'd'
		  end

			it 'knows which partner receiving second point of new game' do
		    expect(@json['p1PartnerUpFirst']).to eq 'a'
		    expect(@json['p1PartnerUpSecond']).to eq 'b'
		  end

		end

	end	
end
