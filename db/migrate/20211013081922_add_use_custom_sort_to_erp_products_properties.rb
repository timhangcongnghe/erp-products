class AddUseCustomSortToErpProductsProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_properties, :use_custom_sort, :boolean, default: false
  end
end
