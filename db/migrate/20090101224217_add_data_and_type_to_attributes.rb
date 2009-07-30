class AddDataAndTypeToAttributes < ActiveRecord::Migration
  def self.up
    change_table :actattributes do |t|
      transaction do
        t.string :data
        t.string :data_type
      end
    end
  end

  def self.down
    change_table :actattributes do |t|
      t.remove :data
      t.remove :data_type
    end
  end
end
