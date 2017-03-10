class CreateErpProductsRelatedCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_related_categories do |t|
      t.string :name
      t.references :parent, index: true, references: :erp_products_categories
      t.references :category, index: true, references: :erp_products_categories

      t.timestamps
    end
  end
end
