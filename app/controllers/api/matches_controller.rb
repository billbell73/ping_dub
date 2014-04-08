class Api::MatchesController < ApplicationController

	def update
		@match = Match.find(params[:id])
		if params[:decrement]
			@match.decrement_score(params[:p_number])
		else
			@match.increment_score(params[:p_number])
		end
	end

end