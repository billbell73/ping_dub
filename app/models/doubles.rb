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

	def p1_partner_up_second
		if p1_first_partner_involved?
			self.p1.players.last.name
		else
			self.p1.players.first.name
		end
	end

	def p2_partner_up_second
		if p2_first_partner_involved?
			self.p2.players.last.name
		else
			self.p2.players.first.name
		end
	end

	def p1_partner_up_first
		if p1_first_partner_involved?
			self.p1.players.first.name
		else
			self.p1.players.last.name
		end
	end

	def p2_partner_up_first
		if p2_first_partner_involved?
			self.p2.players.first.name
		else
			self.p2.players.last.name
		end
	end

	def p1_first_partner_involved?
		if current_game.p1_started_game_serving 
			initial_serving_pair_first_partner_involved?
		else
			initial_receiving_pair_first_partner_involved?
		end
	end

	def p2_first_partner_involved?
		if current_game.p1_started_game_serving 
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

	def doubles_server
		serving_pair = p1_serving? ? self.p1 : self.p2
		if self.server_is_first_partner? 
			serving_pair.players.first
		else
			serving_pair.players.last
		end	
	end

	def doubles_receiver
		receiving_pair = p1_serving? ? self.p2 : self.p1
		if self.receiver_is_first_partner?
			receiving_pair.players.first
		else
			receiving_pair.players.last
		end
	end
	
end