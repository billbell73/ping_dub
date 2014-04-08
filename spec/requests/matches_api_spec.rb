require 'spec_helper'

describe 'Matches API' do

	let(:player) { create(:player) }
	let(:player2) { create(:player) }

	let(:match) { create(:match, p1: player, p2: player2) }
	

	def increment_score(player_number)
	  patch api_match_path(match), { p_number: player_number } 

	  @response, @json = response, JSON.parse(response.body)
	end

	it 'returns a success status code' do
		create(:game, match: match)
	  increment_score(1)
	  expect(@response).to be_success
	end

	it 'can increment score for a player' do
		create(:game, match: match)
	  expect { increment_score(1) }.to change{ match.current_game.
		                                              player_points(player) }.by(1)
	end
	
end