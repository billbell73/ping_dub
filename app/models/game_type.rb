class GameType
	def initialize(p1_starts_left, p1_first_server, match=nil)
		@p1_starts_left = p1_starts_left
		@p1_first_server = p1_first_server
		@match = match
	end

	def serve_toggle(points_played)
		if points_played < 20
			(points_played/2) % 2
		else
			points_played % 2
		end 
	end

end

class OddGame < GameType
	def p1_on_left?(max_points)
		@p1_starts_left
	end

	def p1_serving?(points_played)
		serve_toggle(points_played) == 0? @p1_first_server : !@p1_first_server
	end
end


class EvenGame < GameType
	def p1_on_left?(max_points)
		!@p1_starts_left
	end

	def p1_serving?(points_played)
		serve_toggle(points_played) == 0? !@p1_first_server : @p1_first_server
	end
end

class LastGame < OddGame
	def p1_on_left?(max_points)
		check_for_doubles_order_switch if max_points == 5
		max_points < 5 ? @p1_starts_left : !@p1_starts_left
	end

	def check_for_doubles_order_switch
		unless @match.current_game.receiver_order_switched
			if @match.p1_serving? 
				new_order = !@match.current_game.p2_partners_in_id_order 
				@match.current_game.update(receiver_order_switched: true, 
				                           p2_partners_in_id_order: new_order)
			else
				new_order = !@match.current_game.p1_partners_in_id_order 
				@match.current_game.update(receiver_order_switched: true, 
				                           p1_partners_in_id_order: new_order)
			end
		end
	end

end