class AddConfirmedAtToErpProductsStockChecks < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_stock_checks, :confirmed_at, :datetime
  end
end
