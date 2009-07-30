class AddAdminFlagToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.boolean :is_admin, :default => false
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :is_admin
    end
  end
end
