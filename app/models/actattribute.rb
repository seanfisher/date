class Actattribute < ActiveRecord::Base
  belongs_to :attcategory
  has_and_belongs_to_many :activities
  acts_as_fleximage do
    image_directory  'public/images/uploaded_images'
    require_image    false
  end
  
  validates_presence_of :title
end
