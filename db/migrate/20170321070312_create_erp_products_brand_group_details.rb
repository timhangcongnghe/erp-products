class CreateErpProductsBrandGroupDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_brand_group_details do |t|
      t.references :brand, index: true, references: :erp_products_brands
      t.references :brand_group, index: true, references: :erp_products_brand_groups

      t.timestamps
    end
  end
end
