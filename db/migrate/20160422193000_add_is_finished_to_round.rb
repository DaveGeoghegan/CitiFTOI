class AddIsFinishedToRound < ActiveRecord::Migration
  def change
    create_table :team_rounds do |t|
      t.integer :team_id
      t.integer :round_id
      t.boolean :is_finished
      t.datetime :finish_date
      t.timestamps null: false
    end
  end
end
