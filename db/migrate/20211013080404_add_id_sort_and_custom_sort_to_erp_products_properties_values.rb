class AddIdSortAndCustomSortToErpProductsPropertiesValues < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_properties_values, :id_sort, :integer
    add_column :erp_products_properties_values, :custom_sort, :string
  end
end
