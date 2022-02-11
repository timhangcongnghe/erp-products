def self.get_active
  self.all
end

def self.get_all_unarchive
  self.where(archived: false)
end

def self.get_top_categories
  self.where(parent_id: nil)
end

def self.get_has_parent_categories
  self.where.not(parent_id: nil)
end

def get_products_home_page
  self.products.get_active.order('created_at desc').limit(6)
end

def self.get_stock_categories
  self.where(id: Erp::Products::Product.get_stock_inventory_products.distinct.pluck(:category_id))
end

def category_get_properties_array
  groups = []
  return [] if self.nil?
  property_group = self.property_groups.where(is_filter_specs: true).first
  property_group.properties.each do |property|
    row = {}
    row[:name] = property.name
    row[:values] = []
    values = property.properties_values.order('custom_order ASC').get_property_values_for_filter.map {|pv| pv }
    row[:values] += values if !values.empty?
    groups << row if !row[:values].empty?
  end
  return groups
end

def get_self_and_children_ids
  ids = [self.id]
  ids += get_children_ids_recursive
  return ids
end

def get_children_ids_recursive
  ids = []
  children.each do |c|
    if !c.children.empty?
      ids += c.get_children_ids_recursive
    end
    ids << c.id
  end
  return ids
end

def self.filter(query, params)
  params = params.to_unsafe_hash
  and_conds = []
  show_archived = false
  if params['filters'].present?
    params['filters'].each do |ft|
      or_conds = []
      ft[1].each do |cond|
        if cond[1]['name'] == 'show_archived'
          show_archived = true
        else
          or_conds << "#{cond[1]['name']} = '#{cond[1]['value']}'"
        end
      end
      and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
    end
  end
  if params['keywords'].present?
    params['keywords'].each do |kw|
      or_conds = []
      kw[1].each do |cond|
        or_conds << "LOWER(#{cond[1]['name']}) LIKE '%#{cond[1]['value'].downcase.strip}%'"
      end
      and_conds << '('+or_conds.join(' OR ')+')'
    end
  end
  query = query.joins('LEFT JOIN erp_products_categories parents_erp_products_categories ON parents_erp_products_categories.id = erp_products_categories.parent_id')
  if show_archived == true
    query = query.where(archived: true)
  else
    query = query.where(archived: false)
  end
  query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
  if params[:keyword].present?
    keyword = params[:keyword].strip.downcase
    keyword.split(' ').each do |q|
      q = q.strip
      query = query.where('LOWER(erp_products_categories.name) LIKE ?', '%'+q+'%')
    end
  end
  return query
end