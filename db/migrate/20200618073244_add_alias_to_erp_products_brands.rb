class AddAliasToErpProductsBrands < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_brands, :alias, :string
  end
end
