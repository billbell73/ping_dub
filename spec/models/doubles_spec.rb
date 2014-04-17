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
		              p1_partners_in_id_order: true,
		              p2_partners_in_id_order: false)
	end
	
	context 'when first partners contend initial point' do


		it 'knows offsets for pair1' do
			expect(match3.partner_order_offset(1)).to eq 0
			expect(match3.serve_offset(1)).to eq 2
		end

		it 'knows offsets for pair2' do
			expect(match3.partner_order_offset(2)).to eq 4
			expect(match3.serve_offset(2)).to eq 0
		end

		it 'knows which of pair1 involved in first shot of game' do
			expect(match3.partner_up_first(1)).to eq 'a'
			expect(match3.partner_up_second(1)).to eq 'b'
		end

		it 'knows which of pair2 involved in first shot of game' do
			expect(match3.partner_up_first(2)).to eq 'd'
			expect(match3.partner_up_second(2)).to eq 'c'
		end

		it 'knows which of pair 1 involved in 1st shot of point 6' do
			increment(5, match3, 1)
			expect(match3.partner_up_first(1)).to eq 'b'
			expect(match3.partner_up_second(1)).to eq 'a'
		end

		it 'knows which of pair 2 involved in 1st shot of point 10' do
			increment(9, match3, 1)
			expect(match3.partner_up_first(2)).to eq 'd'
			expect(match3.partner_up_second(2)).to eq 'c'
		end

	end

	context 'when server is first partner receiver is second for initial point' do

		before do
			create(:game, match: match3,
			              p1_started_game_serving: false,
			              p1_partners_in_id_order: false,
		              	p2_partners_in_id_order: true)
		end

		it 'knows which partner of pair1 is involved in 3rd point' do
			increment(2, match3, 1)
			expect(match3.partner_up_first(1)).to eq 'b'
			expect(match3.partner_up_second(1)).to eq 'a'
		end

		it 'knows server choice for next game' do
    	expect(match3.next_game_server_choice(0).name).to eq 'a'
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
