require 'spec_helper'

describe Game do

  it { should belong_to(:winner) }
  it { should belong_to(:match) }
  it { should have_many(:points) }

  it 'can tell game score for a player' do
  	player1 = create(:player)
  	game1 = create(:game)
  	5.times{ create(:point, winner: player1, game: game1) }
		expect(game1.player_points(player1)).to eq 5
	end

	it 'can tell game score for a player\'s opponent' do
  	player1 = create(:player)
  	player2 = create(:player)
  	game1 = create(:game)
  	3.times{ create(:point, winner: player2, game: game1) }
		expect(game1.opponent_points(player1)).to eq 3
	end



end
