require 'spec_helper'

describe 'Matches API' do

	let(:player1) { create(:player) }
	let(:player2) { create(:player) }
	let(:match) { create(:match, p1: player1, 
	                             p2: player2,
	                             best_of: 3) }

	before do
		create(:game, match: match)
	end


	def increment_score(player_number)
	  patch api_match_path(match), { p_number: player_number } 
	  @response, @json = response, JSON.parse(response.body)
	end

	def decrement_score(player_number)
    patch api_match_path(match), { p_number: player_number, decrement: true } 
		@response, @json = response, JSON.parse(response.body)
  end

	it 'returns a success status code' do
	  increment_score(1)
	  expect(@response).to be_success
	end

	it 'can increment score for a player' do
	  expect { increment_score(1) }.to change{ match.current_game.
	                                            player_points(player1) }.by(1)
	end

	it 'can decrement score for a player' do
    5.times{increment_score(1)}
    expect { decrement_score(1) }.to change { match.current_game.
		                                           player_points(player1) }.by(-1)
  end

	it 'returns current state of game' do
    5.times{increment_score(1)}
    11.times{increment_score(2)}
    4.times{increment_score(1)}
    expect(@json['p1points']).to eq 4
    expect(@json['p2points']).to eq 0
    expect(@json['p1games']).to eq 0
    expect(@json['p2games']).to eq 1
  end

  it 'will start new game on receipt of post request' do
  	post api_matches_path, { p1_name: 'Geoff', p2_name: 'Mel' } 
		@response, @json = response, JSON.parse(response.body)
		match = Match.find(@json['match_id'])
		expect(match.p2.name).to eq 'Mel'
  end
	
end