require 'spec_helper'

describe "doubles-only methods" do

	def increment(points, match, pair_number)
		points.times{ match.increment_score(pair_number) }
	end
  
	let (:party1) { create(:party)}
	let (:party2) { create(:party)}
  let (:match3) { create(:match, doubles_match: true,
  	                            p1: party1, 
	                            	p2: party2,
	                            	p1_first_server: true,
	                            	p1_starts_left: true,
	                            	best_of: 3) }

  before do
  	create(:player, name: 'a', party: party1) 
  	create(:player, name: 'b', party: party1) 
  	create(:player, name: 'c', party: party2) 
  	create(:player, name: 'd', party: party2)

  	create(:game, match: match3,
		              p1_started_game_serving: true,
		              initial_server_first_partner: true,
		              initial_receiver_first_partner: true)
	end
	
	context 'when first partners contend initial point' do

		it 'knows which of initial server pair is involved in 1st shot of point 1' do
			expect(match3.initial_serving_pair_first_partner_involved?)
																																.to equal true
		end

		it 'knows which of initial server pair is involved in 1st shot of point 6' do
			increment(5, match3, 1)
			expect(match3.initial_serving_pair_first_partner_involved?)
																																.to equal false
		end

		it 'knows which partner of pair is serving for 5th point' do
			increment(4, match3, 1)
			expect(match3.server_is_first_partner?).to equal false
		end

		it 'knows which partner of pair is receiving for 7th point' do
			increment(6, match3, 1)
			expect(match3.receiver_is_first_partner?).to equal true
		end

		it 'knows who is serving for 8th point' do
			increment(7, match3, 1)
			expect(match3.doubles_server.name).to eq 'd'
		end

		it 'knows who is receiving for 8th point' do
			increment(7, match3, 1)
			expect(match3.doubles_receiver.name).to eq 'a'
		end

	end

	context 'when server is first partner receiver is second for initial point' do

		before do
			create(:game, match: match3,
			              p1_started_game_serving: false,
			              initial_server_first_partner: true,
			              initial_receiver_first_partner: false)
		end

		it 'knows which partner of pair is serving for 3rd point' do
			increment(2, match3, 1)
			expect(match3.receiver_is_first_partner?).to equal false
		end

		it 'knows which partner of pair is receiving for 5th point' do
			increment(4, match3, 1)
			expect(match3.receiver_is_first_partner?).to equal true
		end

		it 'knows who is serving for 9th point' do
			increment(8, match3, 1)
			expect(match3.doubles_server.name).to eq 'c'
		end

		it 'knows who is receiving for 5th point' do
			increment(4, match3, 1)
			expect(match3.doubles_receiver.name).to eq 'a'
		end

	end

	context 'Starting a doubles match with passed match choices' do

		let(:match4) { Match.start_match(nil, nil, 3, true, true, 
			                               'a', 'b', 'c', 'd',
			                               true, true, "true") }

		it 'can start match' do
			expect(match4.games.count).to eq 1
			expect(match4.current_game.points.count).to eq 0
			expect(match4.best_of).to eq 3
			expect(match4.p1_first_server).to eq true
		end

		it 'starts match with correct parties and names' do
			expect(match4.p1.name).to eq 'a and b'
			expect(match4.p2.name).to eq 'c and d'
			expect(match4.p1.players.first.name).to eq 'a'
			expect(match4.p2.players.last.name).to eq 'd'
		end

	end


end
