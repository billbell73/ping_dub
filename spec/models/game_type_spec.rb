require 'spec_helper'

describe GameType do

	let(:game) { GameType.new(true,true)}

	it 'mandates 2 serves from one player then 2 serves by other in normal play' do
		expect(game.serve_toggle(0)).to equal 0							
		expect(game.serve_toggle(1)).to equal 0
		expect(game.serve_toggle(2)).to equal 1
		expect(game.serve_toggle(3)).to equal 1
	end

	it 'mandates alternate serves after 10-all' do
		expect(game.serve_toggle(20)).to equal 0							
		expect(game.serve_toggle(21)).to equal 1
		expect(game.serve_toggle(22)).to equal 0
		expect(game.serve_toggle(23)).to equal 1
	end

end

describe LastGame do 

	context 'switching in last possible game when party reaches 5 points' do

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
			['a', 'b'].each { |name| create(:player, name: name, party: party1) }
			['c', 'd'].each { |name| create(:player, name: name, party: party2) }
			2.times { create(:game, match: match3) }
			create(:game, match: match3,
		              p1_started_game_serving: true,
		              p1_partners_in_id_order: false,
	              	p2_partners_in_id_order: true)
			increment(4, match3, 2)
		end

		context 'singles or doubles' do

			it 'will give normal odd-game end position before someone reaches 5' do
				expect(match3.p1_on_left?).to equal true
			end

			it 'will give opposite of normal odd-game position after first player has reached 5' do
				increment(1, match3, 2)
				expect(match3.p1_on_left?).to equal false
			end

		end

		context 'receiver-switching in doubles matches' do

			it 'check in third game, at 0-4, receiver is \'d\'', :focus => true do
				expect(match3.nth_game).to eq 3
				expect(match3.max_points).to eq 4
				expect(match3.p1_serving?).to eq true
				expect(match3.partner_up_first(2)).to eq 'd'
			end

			it 'at 0-5, receiver is \'c\' (not \'d\')', :focus => true do
				increment(1, match3, 2)
				expect(match3.p1_serving?).to eq true
				match3.p1_on_left?
				expect(match3.partner_up_first(2)).to eq 'c'
			end

			it 'after switching at 0-5, receiver doesn\'t switch again', :focus => true do
				increment(1, match3, 2)
				match3.p1_on_left?
				expect(match3.partner_up_first(2)).to eq 'c'
				increment(1, match3, 2)
				match3.p1_on_left?
				expect(match3.partner_up_first(1)).to eq 'b'
				increment(2, match3, 2)
				match3.p1_on_left?
				expect(match3.partner_up_first(2)).to eq 'd'
			end

			it 'at 2-4 receiver is \'b\', at 2-5 it becomes \'a\'', :focus => true do
				increment(2, match3, 1)
				expect(match3.p1_serving?).to eq false
				match3.p1_on_left?
				expect(match3.partner_up_first(1)).to eq 'b'
				increment(1, match3, 2)
				match3.p1_on_left?
				expect(match3.partner_up_first(1)).to eq 'a'
			end

		end

	end
	
end