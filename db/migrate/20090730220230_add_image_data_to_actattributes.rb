class AddImageDataToActattributes < ActiveRecord::Migration
  def self.up
    add_column :actattributes, :image_filename, :string
    add_column :actattributes, :image_width, :integer
    add_column :actattributes, :image_height, :integer
  end

  def self.down
    remove_column :actattributes, :image_filename
    remove_column :actattributes, :image_width
    remove_column :actattributes, :image_height
  end
end
