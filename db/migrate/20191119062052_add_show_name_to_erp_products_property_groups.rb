class AddShowNameToErpProductsPropertyGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_property_groups, :show_name, :string
  end
end