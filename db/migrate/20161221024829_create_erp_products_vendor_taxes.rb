class CreateErpProductsVendorTaxes < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_vendor_taxes do |t|
      t.references :product, index: true, references: :erp_products_products
      t.references :tax, index: true, references: :erp_taxes_taxes

      t.timestamps
    end
  end
end
