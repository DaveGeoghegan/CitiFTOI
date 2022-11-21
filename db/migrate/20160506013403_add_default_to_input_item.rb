class AddDefaultToInputItem < ActiveRecord::Migration
  def change
    add_column :input_items,  :default_value , :float
  end
end
