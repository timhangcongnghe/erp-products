class AddIsMainToErpProductsBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_brands, :is_main, :boolean, default: false
  end
end
