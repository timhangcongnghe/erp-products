class AddStockToErpProductsStockCheckDetails < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_stock_check_details, :stock, :integer
  end
end
