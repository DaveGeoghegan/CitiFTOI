class AddAttachmentEconomicDataToRounds < ActiveRecord::Migration
  def self.up
    change_table :rounds do |t|
      t.attachment :economic_data
    end
  end

  def self.down
    remove_attachment :rounds, :economic_data
  end
end
