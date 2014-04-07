require 'spec_helper'

describe Game do

  it { should belong_to(:winner) }
  it { should belong_to(:match) }
  it { should have_many(:points) }

  it 'can tell game score for each player' do
  	player1 = create(:player)
  	game1 = create(:game)
  	5.times{ create(:point, winner: player1, game: game1) }
		expect(game1.player_points(player1)).to eq 5
	end

end
