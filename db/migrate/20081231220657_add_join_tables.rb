class AddJoinTables < ActiveRecord::Migration
  def self.up
    create_table :activities_actattributes, :id => false do |t|
      t.integer :activity_id
      t.integer :actattribute_id
    end
    
    create_table :actattributes_activities, :id => false do |t|
      t.integer :actattribute_id
      t.integer :activity_id
    end
  end

  def self.down
    drop_table :activities_actattributes
    drop_table :actattributes_activities
  end
end
