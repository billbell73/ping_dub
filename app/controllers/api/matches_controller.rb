class Api::MatchesController < ApplicationController

	protect_from_forgery with: :null_session

	def create
		@match = Match.start_match(params[:p1_name], 
		                           params[:p2_name],
		                           params[:best_of],
		                           params[:p1_first_server],
		                           params[:p1_starts_left],
		                           params[:partner_a_name],
		                           params[:partner_b_name],
		                           params[:partner_c_name],
		                           params[:partner_d_name],
		                           params[:initial_server_first_partner],
		                           params[:initial_receiver_first_partner],
		                           params[:doubles_match])
	end

	def show
		@match = Match.find(params[:id])
	end

	def update
		@match = Match.find(params[:id])
		if params[:nextServer]
			@match.new_game(params[:nextServer])
		elsif params[:decrement]
			@match.decrement_score(params[:p_number])
		else
			@match.increment_score(params[:p_number])
		end
		render :show
	end

	

end