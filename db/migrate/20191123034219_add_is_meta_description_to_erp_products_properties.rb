class AddIsMetaDescriptionToErpProductsProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_properties, :is_meta_description, :boolean, default: false
  end
end
