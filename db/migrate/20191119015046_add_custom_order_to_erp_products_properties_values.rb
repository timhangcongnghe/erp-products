class AddCustomOrderToErpProductsPropertiesValues < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_properties_values, :custom_order, :integer, default: 0
  end
end
