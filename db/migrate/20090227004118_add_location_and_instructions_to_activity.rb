class AddLocationAndInstructionsToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :location, :string, {:limit => 60, :default => ""}
    add_column :activities, :instructions, :text
  end

  def self.down
    remove_column :activities, :location
    remove_column :activities, :instructions
  end
end
