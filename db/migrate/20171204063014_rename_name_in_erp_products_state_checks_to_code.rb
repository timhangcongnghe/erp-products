class RenameNameInErpProductsStateChecksToCode < ActiveRecord::Migration[5.1]
  def change
    rename_column :erp_products_state_checks, :name, :code
  end
end
