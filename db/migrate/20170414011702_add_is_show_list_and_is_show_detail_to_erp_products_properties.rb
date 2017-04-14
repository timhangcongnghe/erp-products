class AddIsShowListAndIsShowDetailToErpProductsProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_properties, :is_show_list, :boolean, detail: false
    add_column :erp_products_properties, :is_show_detail, :boolean, detail: false
  end
end
