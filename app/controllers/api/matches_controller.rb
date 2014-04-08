class Api::MatchesController < ApplicationController

	def update
		@match = Match.find(params[:id])
		@match.increment_score(params[:p_number])

	end

end