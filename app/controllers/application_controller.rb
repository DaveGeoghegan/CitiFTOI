class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  helper_method :is_admin

  helper_method :current_simulation

  helper_method :current_team_round
  helper_method :previous_team_round
  helper_method :next_team_round

  def current_user
    @current_user ||= Team.find(session[:team_id]) if session[:team_id]
  end

  def is_admin
    @current_user ||= Team.find(session[:team_id]) if session[:team_id]
    if @current_user.nil?
      return nil
    end
    if @current_user.name == "psi"
      return true
    end
    return false
  end


  def current_simulation
    @current_simulation = Simulation.get_current_simulation
  end

  def current_team_round
    if current_user.nil?
      return nil
    end
    current_user.team_rounds.each_with_index do |round, idx|
      if !round.is_finished
        return round
      end
    end
    return TeamRound.last
  end


  def previous_team_round
    if current_user.nil?
      return nil
    end
    current_user.team_rounds.each_with_index do |val, idx|
      if current_team_round == val then
        if idx == 0 then
          return nil
        else
          return current_user.team_rounds[idx-1]
        end
      end
    end
  end

  def next_team_round
    if current_user.nil?
      return nil
    end
    current_user.team_rounds.each_with_index do |val, idx|
      if current_team_round == val then
        if idx == current_user.team_rounds.length - 1 then
          return nil
        else
          return current_user.team_rounds[idx+1]
        end
      end
    end
  end

end
