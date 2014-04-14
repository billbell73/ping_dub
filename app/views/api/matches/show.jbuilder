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
	json.p1PartnerUpFirst @match.p1_partner_up_first
	json.p1PartnerUpSecond @match.p1_partner_up_second
	json.p2PartnerUpFirst @match.p2_partner_up_first
	json.p2PartnerUpSecond @match.p2_partner_up_second
else
  json.p1name @match.p1.name
  json.p2name @match.p2.name
end

