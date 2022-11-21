class CreateDecisions < ActiveRecord::Migration
  def change
    create_table :decisions do |t|
      t.integer :team_round_id
      t.integer :input_item_id
      t.string :value
      t.timestamps  null: false
    end
  end
end
