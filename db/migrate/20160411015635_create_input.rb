class CreateInput < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.string :name
      t.string :kind
      t.string :label
      t.integer :min
      t.integer :max
      t.string :string_default
      t.string :integer_default
      t.timestamps null: false
    end
  end
end
