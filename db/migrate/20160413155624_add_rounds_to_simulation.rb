class AddRoundsToSimulation < ActiveRecord::Migration
  def change
    add_column :simulations,  :number_of_rounds , :integer
  end
end
