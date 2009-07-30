class Image < ActiveRecord::Base
  acts_as_fleximage do
    image_directory 'public/images/uploaded_images'
    require_image true
  end
  
  validates_presence_of :name
end
