require 'spec_helper'

describe 'Matches API' do

	let(:player) { create(:player) }
	let(:match) { create(:match, p1: player) }

	def increment_score(player)
	  patch api_match_path(match), { player_id: player.id } 

	  @response, @json = response, JSON.parse(response.body)
	end

	it 'returns a success status code' do
		create(:game, match: match)
	  increment_score(player)
	  expect(@response).to be_success
	end

	it 'can increment score for a player' do
		create(:game, match: match)
	  expect { increment_score(player) }.to change{ match.current_game.
		                                              player_points(player) }.by(1)
	end
	
end