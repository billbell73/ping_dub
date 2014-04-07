require 'spec_helper'

describe Match do
  
  it { should belong_to(:winner) }
  it { should belong_to(:p1) }
  it { should belong_to(:p2) }

  it { should have_many(:games) }

  it 'can be a doubles match or not' do
		match = Match.create(doubles_match: false)
		expect(match.doubles_match).to eq false
	end

	it 'can increment score' do
		player1 = create(:player)
		match = create(:match, p1_id: player1)
		game = create(:game, match: match)
		2.times{ match.increment_score(player1) }
		expect(game.player_points(player1)).to eq 2
	end

end
