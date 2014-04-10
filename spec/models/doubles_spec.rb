require 'spec_helper'

describe "doubles methods" do
  
	let (:party1) { create(:party)}
	let (:party2) { create(:party)}

	let (:player1) { create(:player, party: party1) }
  let (:player2) { create(:player, party: party1) }
  let (:player3) { create(:player, party: party2) }
  let (:player4) { create(:player, party: party2) }

  let (:match3) { create(:match, doubles_match: true,
  	                            p1: party1, 
	                            	p2: party2,
	                            	p1_first_server: true,
	                            	p1_starts_left: true,
	                            	best_of: 3) }

 	def increment(points, match, pair_number)
		points.times{ match.increment_score(pair_number) }
	end
	
	context 'when first partners contend initial point' do
		
		before do
			create(:game, match: match3,
				              p1_started_game_serving: true,
				              initial_server_first_partner: true,
				              initial_receiver_first_partner: true)
		end

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

	end

	context 'when server is first partner receiver is second for initial point' do

		before do
			create(:game, match: match3,
				              p1_started_game_serving: true,
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

	end

end
