class Api::MatchesController < ApplicationController

	protect_from_forgery with: :null_session

	def show
		@match = Match.find(params[:id])
	end

	def update
		@match = Match.find(params[:id])
		if params[:decrement]
			@match.decrement_score(params[:p_number])
		else
			@match.increment_score(params[:p_number])
		end
	end

end