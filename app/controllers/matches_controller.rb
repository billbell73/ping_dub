class MatchesController < ApplicationController
  def index
  	@Matches = Match.all
  end

  def show
  	@match = Match.find(params[:id])
  	@p1 = @match.p1
  	@current_game = @match.games.last
  end

end
