class CreateAttcategories < ActiveRecord::Migration
  def self.up
    create_table :attcategories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :attcategories
  end
end
