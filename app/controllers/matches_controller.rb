class MatchesController < ApplicationController
  def index
  	@Matches = Match.all
  end

end
