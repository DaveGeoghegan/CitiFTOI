class InputScreen < ActiveRecord::Base

  has_many :round_input_screens
  has_many :rounds , :through  => :round_input_screens

  has_many :input_items

  def has_decisions(tr)
    possible_ids = self.input_items.ids
    decisions = Decision.where(:team_round => tr).where('input_item_id IN (?)',possible_ids)
    if decisions.size > 0 then
      return true
    else
      return false
    end
  end
end
