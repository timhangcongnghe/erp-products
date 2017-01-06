class CreateErpProductsProductsValues < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_products_values do |t|
      t.references :products_property, index: true, references: :erp_products_properties
      t.references :properties_value, index: true, references: :properties_values
    end
  end
end
