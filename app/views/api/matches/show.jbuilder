json.p1points @match.current_game.player_points(@match.p1)
json.p2points @match.current_game.player_points(@match.p2)
json.p1games @match.games_won(@match.p1)
json.p2games @match.games_won(@match.p2)
json.isP1Serving @match.p1_serving?
json.isP1Left @match.p1_on_left?