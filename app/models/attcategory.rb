class Attcategory < ActiveRecord::Base
  has_many :actattributes, :uniq => true, :dependent => :destroy
end
