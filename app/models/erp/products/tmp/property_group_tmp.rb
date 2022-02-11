def self.get_active
  self.all
end

def self.get_for_filter
  self.get_active.where(is_filter_specs: true)
end

def self.get_properties_for_filter
  self.get_active.order('custom_order asc')
end