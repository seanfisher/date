class Activity < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :actattributes
  
  # Validation
  validates_presence_of :duration, :message => "can't be zero!"
  validates_numericality_of :duration, :greater_than => 0
  validates_presence_of :title
  
#  def duration(type="minute")
#    case type
#      when "hour"
#        self.duration_in_hours
#      when "string"
#        self.duration_in_string
#      when "minute"
#      else
#        self.duration_in_minutes
#    end
#  end
  
#  def duration=(t, type = "minute")
#    case type
#      when "hour"
#        self.duration_in_hours = t.to_f
#      when "minute"
#      else
#        self.duration_in_minutes = t.to_f
#    end
#  end
  
  def duration_in_minutes=(t)
    self.duration = t
  end
  
  def duration_in_minutes
    self.duration
  end
  
  def duration_in_hours
    self.duration / 60
  end
  
  def duration_in_hours=(t)
    self.duration = t.to_i * 60
  end
  
  def duration_in_string
    return_string = ""
    minutes = self.duration_in_minutes
    hours = minutes / 60
    minutes = minutes % 60
    if hours > 0
      return_string += "#{hours} "
      return_string += I18n.t(:hour_short) if hours == 1
      return_string += I18n.t(:hours_short) if hours != 1
      return_string += " " if minutes > 0
    end
    if minutes > 0
      return_string += "#{minutes} "+I18n.t(:minutes_short)
    end
    return return_string
  end
  
  def self.search(search, page)
    paginate :per_page => 20, :page => page,
             :conditions => ['title like ?', "%#{search}%"], :order => 'title'
  end
  
  def self.random
    ids = connection.select_all("SELECT #{self.primary_key} FROM #{self.table_name}")
    find(ids[rand(ids.size)][self.primary_key].to_i) unless ids.blank?
  end

  def toggle(actattribute)
    self.actattributes.include?(actattribute) ? self.actattributes.delete(actattribute) : self.actattributes.push(actattribute)
  end

end
