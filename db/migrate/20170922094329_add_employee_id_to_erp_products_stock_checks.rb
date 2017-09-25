class AddEmployeeIdToErpProductsStockChecks < ActiveRecord::Migration[5.1]
  def change
    add_reference :erp_products_stock_checks, :employee, index: true, references: :erp_users
  end
end
