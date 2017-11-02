class AddCacheStockToErpProductsProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_products, :cache_stock, :integer
  end
end
