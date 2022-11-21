class Team < ActiveRecord::Base

  has_many :team_rounds
  has_many :rounds , :through => :team_rounds

  accepts_nested_attributes_for :team_rounds




  def self.authenticate(name, password)
    team = find_by_name(name)
    if team && team.password == password then
      team
    else
      nil
    end
  end

	def get_current_team_round
		self.team_rounds.each_with_index do |round, idx|
			if !round.is_finished
				return round
			end
		end
		return self.team_rounds.last
	end

end
