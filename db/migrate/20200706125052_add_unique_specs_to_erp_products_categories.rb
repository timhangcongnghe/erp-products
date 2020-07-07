class AddUniqueSpecsToErpProductsCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_categories, :unique_specs, :boolean, default: false
  end
end