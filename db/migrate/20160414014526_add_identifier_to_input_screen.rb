class AddIdentifierToInputScreen < ActiveRecord::Migration
  def change
    add_column :input_screens,  :identifier , :string
  end
end
