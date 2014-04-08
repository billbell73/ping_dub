class Api::MatchesController < ApplicationController

	def update
		@match = Match.find(params[:id])
		@player = Player.find(params[:player_id])
		@match.increment_score(@player)

	end

end