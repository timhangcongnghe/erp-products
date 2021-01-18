class AddIsFilterSpecsToErpProductsPropertyGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_property_groups, :is_filter_specs, :boolean, default: false
  end
end