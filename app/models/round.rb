class Round < ActiveRecord::Base

  belongs_to :simulation

  has_many :round_input_screens
  has_many :input_screens , :through => :round_input_screens

  has_many :team_rounds
  has_many :teams , :through => :team_rounds

  has_attached_file :economic_data
  has_attached_file :debrief

  validates_attachment_content_type :economic_data, :content_type => ['application/pdf', 'application/msword', 'text/plain'], :if => :pdf_attached?

  validates_attachment_content_type :debrief, :content_type => ['application/vnd.openxmlformats-officedocument.presentationml.presentation' , 'application/pdf', 'application/msword', 'text/plain'], :if => :debrief_attached?

  def pdf_attached?
    self.economic_data.file?
  end

  def debrief_attached?
    self.debrief.file?
  end

  def get_next_input_screen(is)
    current_index = self.input_screens.find_index(is)
    if is.nil? then
      return nil
    end
    if (current_index + 1) >= self.input_screens.size then
      return nil
    end
    puts  "Getting Next Input Screen"
    ap self.input_screens[current_index + 1]
    return self.input_screens[current_index + 1]
  end

  def get_prev_input_screen(is)
    current_index = self.input_screens.find_index(is)
    if is.nil? then
      return nil
    end
    if (current_index - 1) < 0 then
      return nil
    end
    puts  "Getting Prev Input Screen"
    ap self.input_screens[current_index - 1]
    return self.input_screens[current_index - 1]
  end
end
