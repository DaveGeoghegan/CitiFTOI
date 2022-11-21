class CreateSimulation < ActiveRecord::Migration
  def change
    create_table :simulations do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
