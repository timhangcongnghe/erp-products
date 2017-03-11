class CreateErpProductsCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_categories do |t|
      t.string :image_url
      t.string :name
      t.text :description
      t.integer :parent_id
      t.text :meta_keywords
      t.text :meta_description
      t.boolean :archived, default: false
      t.references :creator, index: true, references: :erp_users
      t.integer :custom_order

      t.timestamps
    end
  end
end
