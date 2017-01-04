class CreateErpProductsPropertiesValues < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_properties_values do |t|
      t.references :property, index: true, references: :erp_products_properties
      t.string :value
    end
  end
end
