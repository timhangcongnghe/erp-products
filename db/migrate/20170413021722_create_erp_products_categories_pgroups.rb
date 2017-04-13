class CreateErpProductsCategoriesPgroups < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_categories_pgroups do |t|
      t.references :category, index: true, references: :erp_products_categories
      t.references :property_group, index: true, references: :erp_products_property_groups

      t.timestamps
    end
  end
end
