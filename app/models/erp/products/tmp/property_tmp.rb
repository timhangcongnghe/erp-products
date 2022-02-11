def self.get_properties_for_filter
  self.get_active.where(is_show_website: true).order('custom_order asc')
end