class AddCachePropertiesToErpProductsProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_products, :cache_properties, :text
  end
end
