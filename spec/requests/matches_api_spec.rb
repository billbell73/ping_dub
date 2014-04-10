require 'spec_helper'

describe 'Matches API' do

	let(:player1) { create(:party, name: 'Gee') }
	let(:player2) { create(:party, name: 'Zob') }
	let(:match) { create(:match, p1: player1, 
	                             p2: player2,
	                             p1_first_server: true,
                               p1_starts_left: true,
  	                           best_of: 5) }

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
    expect(@json['isP1Left']).to eq false
    expect(@json['isP1Serving']).to eq false
    expect(@json['p2name']).to eq 'Zob'
  end

  it 'returns match winner name when match won' do
    32.times{increment_score(1)}
    expect(@json['matchWinner']).to eq nil
    increment_score(1)
    expect(@json['matchWinner']).to eq 'Gee'
  end

  it 'returns game winner name when game just won' do
    10.times{increment_score(1)}
    expect(@json['gameJustWonBy']).to eq nil
    increment_score(1)
    expect(@json['gameJustWonBy']).to eq 'Gee'
    increment_score(1)
    expect(@json['gameJustWonBy']).to eq nil
  end

  context 'Starting a new match' do

	  it 'will start new game on receipt of post request' do
	  	post api_matches_path, { p1_name: 'Geoff', p2_name: 'Mel' } 
			@response, @json = response, JSON.parse(response.body)
			match = Match.find(@json['match_id'])
			expect(match.p2.name).to eq 'Mel'
	  end

		it 'will initiate match with appropriate match choices' do
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

	end
	
end