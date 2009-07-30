class Actattribute < ActiveRecord::Base
  belongs_to :attcategory
  has_and_belongs_to_many :activities
end
