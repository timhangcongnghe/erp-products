class AddCacheSearchToErpProductsBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_brands, :cache_search, :text
  end
end
