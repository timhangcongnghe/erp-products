def self.get_active
  self.all
end

def self.get_brands
  self.get_active.order('name asc')
end

def self.get_brands_for_frontend
  self.for_filter.where(is_main: true)
end

def self.filter_by_keyword(kw)
  query = self.where('1=1')
  if kw.present?
    keyword = kw.strip.downcase
    keyword.split(' ').each do |q|
      q = q.strip
      query = query.where('LOWER(cache_search) LIKE ?', '%'+q+'%')
    end
  end
  return query
end

def self.get_stock_brands
  self.where(id: Erp::Products::Product.get_stock_inventory_products.distinct.pluck(:brand_id))
end

def self.select2(params=nil, limit=40)
  query = self.order('name asc')
  query = query.filter_by_keyword(params[:q]) if params[:q].present?
  query = query.limit(limit)
  return query.map{|brand| {value: brand.id, text: brand.name}}
end