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

	let(:last_game1) {LastGame.new(false,true)}

	it 'will give normal odd-game end position before someone reaches 5' do
		expect(last_game1.p1_on_left?(4)).to equal false
	end

	it 'will give opposite of normal odd-game position after first player has reached 5' do
		expect(last_game1.p1_on_left?(5)).to equal true
	end
	
end