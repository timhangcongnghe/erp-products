class CreateErpProductsInventoryProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_inventory_products do |t|
      t.string :image_url
      t.string :name
      t.decimal :price, default: 1.0
      t.string :gift
      t.string :product_link
      t.integer :custom_order
      t.string :hot_category_name
      t.boolean :is_stock, default: true
      t.boolean :archived, default: false
      t.references :inventory_category, index: true, references: :erp_products_inventory_categories
      t.references :creator, index: true, references: :erp_users      

      t.timestamps
    end
  end
end
