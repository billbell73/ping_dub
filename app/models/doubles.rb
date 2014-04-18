module Doubles

	def partner_toggle(offset)
		points_played = current_game.total_points
		toggle_number = points_played + offset
		if points_played < 22
			(toggle_number/4) % 2
		else
			(toggle_number/2) % 2
		end 
	end
	
	def partner_order_offset(pair_number)
		if pair_number == 1
			current_game.p1_partners_in_id_order ? 0 : 4
		else
			current_game.p2_partners_in_id_order ? 0 : 4
		end
	end

	def serve_offset(pair_number)
		if pair_number == 1
			current_game.p1_started_game_serving ? 2 : 0
		else
			current_game.p1_started_game_serving ? 0 : 2
		end
	end

	def partner_up_first(pair_number)
		offset = serve_offset(pair_number) + partner_order_offset(pair_number)
		index = partner_toggle(offset)
		self.send("p" + pair_number.to_s).players.offset(index).first.name
	end

	def partner_up_second(pair_number)
		offset = serve_offset(pair_number) + partner_order_offset(pair_number)
		index = partner_toggle(offset) == 0 ? 1 : 0
		self.send("p" + pair_number.to_s).players.offset(index).first.name
	end

	def next_game_server_choice(index)
		if current_game.p1_started_game_serving
			p2.players.offset(index).first
		else
			p1.players.offset(index).first
		end
	end

	def new_game(next_server_id)
		p1_starts_next_game = !current_game.p1_started_game_serving
		if p1_starts_next_game
			new_p1_id_order = next_game_first_server_pair_in_id_order(next_server_id, 1)
			new_p2_id_order = next_game_first_receiver_pair_in_id_order(new_p1_in_order)
		else
			new_p2_id_order = next_game_first_server_pair_in_id_order(next_server_id, 2)
			new_p1_id_order = next_game_first_receiver_pair_in_id_order(new_p1_in_order)
		end
		Game.create(match: self, 
		            p1_started_game_serving: new_p1_start,
		            p1_partners_in_id_order: new_p1_id_order,
		            p2_partners_in_id_order: new_p2_id_order)
	end

	def next_game_first_server_pair_in_id_order(server_id, pair_number)
		Player.find(server_id) == self.send("p" + pair_number.to_s).players.first
	end

	def next_game_first_receiver_pair_in_id_order(new_server_order)
		same_order_now = current_game.p1_partners_in_id_order == 
		                 current_game.p2_partners_in_id_order
		same_order_now ? new_server_order : !new_server_order
	end

end