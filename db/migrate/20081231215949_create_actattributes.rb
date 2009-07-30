class CreateActattributes < ActiveRecord::Migration
  def self.up
    create_table :actattributes do |t|
      t.integer :attcategory_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :actattributes
  end
end
