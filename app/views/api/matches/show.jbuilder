json.p1points @match.current_game.player_points(@match.p1)
json.p2points @match.current_game.player_points(@match.p2)
json.p1games @match.games_won(@match.p1)
json.p2games @match.games_won(@match.p2)
json.isP1Serving @match.p1_serving?
json.isP1Left @match.p1_on_left?
json.matchWinner @match.winner.name if @match.winner
json.gameJustWonBy @match.game_just_won_by
json.doubles @match.doubles_match

if @match.doubles_match
	json.p1PartnerUpFirst @match.partner_up_first(1)
	json.p1PartnerUpSecond @match.partner_up_second(1)
	json.p2PartnerUpFirst @match.partner_up_first(2)
	json.p2PartnerUpSecond @match.partner_up_second(2)
else
  json.p1name @match.p1.name
  json.p2name @match.p2.name
end

if @match.game_just_won_by and @match.doubles_match
	json.nextServerAName @match.next_game_server_choice(0).name
	json.nextServerAId @match.next_game_server_choice(0).id
	json.nextServerBName @match.next_game_server_choice(1).name
	json.nextServerBId @match.next_game_server_choice(1).id
end

