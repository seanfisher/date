# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def badge(actattribute, more = {})
    format = more.include?(:format) ? more[:format] : :png
    more.delete(:format)
    path = badge_path(actattribute, :format => format)
    alt = title = actattribute.title
    options = {:alt => alt, :title => title}.merge!(more) if more.is_a?(Hash)
    image_tag path, options
  end
end
