class CreateInputItems < ActiveRecord::Migration
  def change
    create_table :input_items do |t|
      t.string :name
      t.string :identifier
      t.string :label
      t.string :kind
      t.integer :input_screen_id
      t.timestamps null: false
    end
  end
end
