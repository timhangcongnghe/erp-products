class AddShortNameToErpProductsProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_products, :short_name, :string
  end
end
