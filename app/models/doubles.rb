module Doubles
	
	def server_is_first_partner?
		if(current_game.p1_started_game_serving == p1_serving?)
			initial_serving_pair_first_partner_involved?
		else 
			initial_receiving_pair_first_partner_involved?
		end
	end

	def receiver_is_first_partner?
		if(current_game.p1_started_game_serving == p1_serving?)
			initial_receiving_pair_first_partner_involved?
		else 
			initial_serving_pair_first_partner_involved?
		end
	end

	def initial_receiving_pair_first_partner_involved?
		partner_toggle(0) == 0 ? 
			current_game.initial_receiver_first_partner : 
				!current_game.initial_receiver_first_partner
	end

	def initial_serving_pair_first_partner_involved?
		partner_toggle(2) == 0 ? 
			current_game.initial_server_first_partner : 
				!current_game.initial_server_first_partner
	end

	def partner_toggle(offset)
		points_played = current_game.total_points
		toggle_number = points_played + offset
		if points_played < 22
			(toggle_number/4) % 2
		else
			(toggle_number/2) % 2
		end 
	end
	
end