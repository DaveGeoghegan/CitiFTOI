class CreateInputScreen < ActiveRecord::Migration
  def change
    create_table :input_screens do |t|
      t.string :name
      t.string :navigation_label
      t.timestamps null: false
    end
  end
end
