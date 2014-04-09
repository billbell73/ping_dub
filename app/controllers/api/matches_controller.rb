class Api::MatchesController < ApplicationController

	protect_from_forgery with: :null_session

	def create
		p1_name = params[:p1_name]
		p2_name = params[:p2_name]
		@match = Match.start_match(p1_name, p2_name)
	end

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