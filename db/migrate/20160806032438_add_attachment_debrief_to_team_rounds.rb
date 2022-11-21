class AddAttachmentDebriefToTeamRounds < ActiveRecord::Migration
  def self.up
    change_table :team_rounds do |t|
      t.attachment :debrief
    end
  end

  def self.down
    remove_attachment :team_rounds, :debrief
  end
end
