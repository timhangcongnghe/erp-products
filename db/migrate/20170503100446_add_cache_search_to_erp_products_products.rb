class AddCacheSearchToErpProductsProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_products, :cache_search, :text
  end
end
