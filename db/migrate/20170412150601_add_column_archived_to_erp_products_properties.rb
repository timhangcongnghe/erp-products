class AddColumnArchivedToErpProductsProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_properties, :archived, :boolean, default: false
    add_reference :erp_products_properties, :property_group, index: true, references: :erp_products_property_groups
  end
end
