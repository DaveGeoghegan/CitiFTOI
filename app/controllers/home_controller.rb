class HomeController < ApplicationController
  def index
    puts "Home INdex"
    puts current_user.to_s
    puts "Was Current User"
    puts "Team Round"
    puts @team_round
    if session[:team_id].nil? then
      redirect_to '/sessions/new'
    else
      @team_round = current_team_round
			@round = current_team_round.round
    end
  end

  def about

  end
end
