class AddAliasToErpProductsProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_products, :alias, :string
  end
end
