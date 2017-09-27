class AddIsShowWebsiteToErpProductsProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_properties, :is_show_website, :boolean, default: false
  end
end
