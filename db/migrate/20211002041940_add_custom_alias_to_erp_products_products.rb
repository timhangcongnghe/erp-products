class AddCustomAliasToErpProductsProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_products, :custom_alias, :string
  end
end
