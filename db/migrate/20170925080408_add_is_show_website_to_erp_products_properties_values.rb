class AddIsShowWebsiteToErpProductsPropertiesValues < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_properties_values, :is_show_website, :boolean, default: false
  end
end
