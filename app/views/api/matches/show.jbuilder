json.p1points @match.current_game.player_points(@match.p1)
json.p2points @match.current_game.player_points(@match.p2)
json.p1games @match.games_won(@match.p1)
json.p2games @match.games_won(@match.p2)