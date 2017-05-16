class AddIsStockInventoryToErpProductsProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_products, :is_stock_inventory, :boolean, default: false
  end
end
