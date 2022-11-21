class AddSimulationIdToRound < ActiveRecord::Migration
  def change
    add_column :rounds,  :simulation_id , :integer
  end
end
