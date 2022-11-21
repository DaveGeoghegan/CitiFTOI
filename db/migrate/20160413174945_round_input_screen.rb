class RoundInputScreen < ActiveRecord::Migration
  def change
    create_table :round_input_screens do |t|
      t.integer :round_id
      t.integer :input_screen_id
      t.timestamps null: false
    end
  end
end
