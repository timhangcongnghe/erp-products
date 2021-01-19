class AddIsNewSpecsToErpProductsCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_categories, :is_new_specs, :boolean, default: false
  end
end