class TeamRound < ActiveRecord::Base
  belongs_to :round
  belongs_to :team
  has_attached_file :report
  has_attached_file :debrief
  has_many :decisions



  validates_attachment_content_type :report, :content_type => ['application/pdf', 'application/msword', 'text/plain'], :if => :pdf_attached?

  validates_attachment_content_type :debrief, :content_type => ['application/vnd.openxmlformats-officedocument.presentationml.presentation' ,'application/pdf', 'application/msword', 'text/plain'], :if => :debrief_attached?

  def pdf_attached?
    self.report.file?
	end

	def debrief_attached?
		self.debrief.file?
	end


  def get_progress_string
    total = self.round.input_screens.size
    completed = 0
    self.round.input_screens.each do |is|
      if is.has_decisions(self) then
        completed = completed + 1
      end
    end
    percent = (completed.to_f / total.to_f) * 100.0;
    return "width:" + percent.to_i.to_s + "%"
	end

	def all_screens_have_decisions
		self.round.input_screens.each do |is|
			if !is.has_decisions(self) then
				return false
			end
		end
		return true
	end




end