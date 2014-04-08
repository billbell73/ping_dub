class GameType
	def initialize(p1_starts_left, p1_first_server)
		@p1_starts_left = p1_starts_left
		@p1_first_server = p1_first_server
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
		max_points < 5 ? @p1_starts_left : !@p1_starts_left
	end

end