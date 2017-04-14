class AddCustomOrderToErpProductsProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_properties, :custom_order, :integer, default: 0
  end
end
