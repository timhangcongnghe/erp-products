def self.get_property_values_for_filter
  self.order('value asc')
end
def product_count
  Erp::Products::ProductsValue.where(properties_value: self.id).count
end

def product_count_by_menu(menu)
  Erp::Products::ProductsValue.includes(:product)
    .where(erp_products_products: {is_sold_out: false, category_id: menu.categories.first})
    .where(properties_value: self.id).count
end

def product_count_by_menu_brand(menu)
  Erp::Products::ProductsValue.includes(:product)
    .where(erp_products_products: {is_sold_out: false, category_id: menu.categories.first, brand_id: menu.brand.id})
    .where(properties_value: self.id).count
end