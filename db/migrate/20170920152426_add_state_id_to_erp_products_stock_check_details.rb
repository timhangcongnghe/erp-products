class AddStateIdToErpProductsStockCheckDetails < ActiveRecord::Migration[5.1]
  def change
    add_reference :erp_products_stock_check_details, :state, index: true, references: :erp_products_states
  end
end
