require 'spec_helper'

describe Game do

  it { should belong_to(:winner) }
  it { should belong_to(:match) }
  it { should have_many(:points) }

  let (:player1) { create(:party) }
  let (:player2) { create(:party) }
  let (:game1) { create(:game) }

  def set_score player1_points, player2_points
		player1_points.times{ create(:point, winner: player1, game: game1) }
		player2_points.times{ create(:point, winner: player2, game: game1) }
	end

  it 'can tell game score for a player' do
    set_score 5, 3
		expect(game1.player_points(player1)).to eq 5
	end

	it 'can tell game score for a player\'s opponent' do
  	set_score 5, 3
		expect(game1.opponent_points(player1)).to eq 3
	end

	it 'can tell if game not won' do
		set_score 3, 3
  	3.times{ create(:point, winner: player2, game: game1) }
		expect(game1.record_if_won_game(player2)).to be_nil
    expect(game1.winner).to be_nil
	end

  it 'player 2 wins if reaches 11 and player 1 has none' do
    set_score 0, 11
    expect(game1.record_if_won_game(player2)).not_to be_nil
    expect(game1.winner).to eq player2
  end

  it 'player 1 doesn\'t win if gets 11, but player 2 has 10' do
    set_score 11, 10
    expect(game1.record_if_won_game(player1)).to be_nil
  end

  it 'player 1 wins if gets point at 11-10' do
    set_score 11, 10
    create(:point, winner: player1, game: game1)
    expect(game1.record_if_won_game(player1)).to eq true
  end

  it 'if player 2 has 11, player 1 wins on 13' do
    set_score 13, 11
    game1.record_if_won_game(player1)
    expect(game1.winner).to equal player1
  end

  it 'if player 2 has 14 and player 1 has 13, no winner' do
    set_score 13, 14
    game1.record_if_won_game(player1)
    expect(game1.winner).to be_nil
  end

  it 'can tell total points in game' do
    set_score 13, 14
    expect(game1.total_points).to be 27
  end



end
