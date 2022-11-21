class Simulation < ActiveRecord::Base
  has_many :rounds
  accepts_nested_attributes_for :rounds, allow_destroy: true

  class << self
    def get_current_simulation
      Simulation.first
    end
  end

end
