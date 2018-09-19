class AddConfirmedAtToErpProductsStateChecks < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_state_checks, :confirmed_at, :datetime
  end
end
